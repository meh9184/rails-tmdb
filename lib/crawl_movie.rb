#!/usr/bin/env ruby
require 'net/http'
require 'json'

# TMDB API KEY 셋팅
$tmdb_api_key = YOUR_TMDB_API_KEY   # 자신의 TMDB api_key 입력

# TMDB API에 GET 요청 전송하는 함수
def getDataFromApi(uri)
    return JSON.parse(Net::HTTP.get(uri))
end

# LOCAL SERVER로 POST 요청 전송하는 함수
def postDataToServer(uri, body)
    body['api-call'] = 'true'
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})
    request.body = body.to_json
    return Net::HTTP.new(uri.host, uri.port).request(request)
end

# Ruby 스크립트 파라미터 옵션에 따라 CRAWL 수행할 리스트 생성해주는 함수
def generateCrawlList()

    # 최종 Crawl List 받을 배열
    crawl_list = []

    # 스크립트 실행시 -rating 옵션 또는 -popular 옵션과
    # 상위 몇위 까지 크롤할지의 크기를 입력하면 각 순위대로 영화를 수집
    if (ARGV[0] == '-rating' || ARGV[0] == '-popular') && ARGV.length == 2

        # option에 맞게 uri 파라미터 이름을 저장
        if ARGV[0] == '-rating'
            option = 'top_rated'
        elsif ARGV[0] == '-popular'
            option = 'popular'
        end

        # TMDB API의 GET movie/top_rated 과 movie/popular 리소스의 경우 
        # 각 페이지별로 20개씩 제공하기 때문에 page와 offset을 적절히 계산해야 함

        # 수집할 영화의 숫자 (스크립트 실행시 넘겨받은 파라미터)
        number_of_movie = ARGV[1].to_i()
        # 크롤링할 페이지의 숫자는 20으로 나눈 몫
        number_of_page = number_of_movie / 20
        # 크롤링할 페이지의 숫자는 20으로 나눈 나머지
        number_of_offset = number_of_movie % 20

        # 일단 미리 계산해놀은 페이지의 숫자만큼 각 20개씩 영화 ID 수집 
        for i in 1..number_of_page
            
            # TMDB API GET GET movie/option 리소스 URI를 만들어 20개의 영화 데이터 요청 
            tmdb_api_uri_option = URI("https://api.themoviedb.org/3/movie/#{option}?api_key=#{$tmdb_api_key}&language=en-US&page=#{i}")
            movies_option = getDataFromApi(tmdb_api_uri_option)

            # 각 페이지의 모든 영화 ID 순서대로 crawl_list에 저장
            for j in 0..19
                crawl_list.push(movies_option['results'][j]['id'])
            end
        end

        # 미리 계산해놓은 page 만큼 수집을 완료하면 마지막 페이지에서는 미리 계산한 offset 만큼 영화 ID를 수집
        # TMDB API GET GET movie/option 리소스 URI를 만들어 영화 데이터 요청
        tmdb_api_uri_option = URI("https://api.themoviedb.org/3/movie/#{option}?api_key=#{$tmdb_api_key}&language=en-US&page=#{number_of_page+1}")
        movies_option = getDataFromApi(tmdb_api_uri_option)

        # 20개의 데이터 중 상위 offset 개의 영화 ID를 crawl_list에 저장
        for i in 0..(number_of_offset-1)
            crawl_list.push(movies_option['results'][i]['id'])
        end

    # Ruby 스크립트 실행시 -rating 또는 -popular 옵션을 넣지 않았다면 입력한 파라미터들을 리스트로 복사
    else
        crawl_list = ARGV
    end

    # 크롤할 영화 ID 리스트를 리턴
    return crawl_list
end


# 크롤러가 탐색할 movie_id 리스트
movie_id_list = generateCrawlList()

# 리스트를 순회하며 각각 Movie, People, MovieCredit 정보들을 생성
movie_id_list.each do|movie_id|

    # TMDB API GET Requst에 사용될 URI 미리 선언
    tmdb_api_uri_movie = URI("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{$tmdb_api_key}")
    tmdb_api_uri_movie_credit = URI("https://api.themoviedb.org/3/movie/#{movie_id}/credits?api_key=#{$tmdb_api_key}")

    # LOCAL SERVER POST Requst에 사용될 URI 미리 선언
    local_server_uri_movie = URI("http://localhost:3000/movies")
    local_server_uri_person = URI("http://localhost:3000/people")
    local_server_uri_movie_credit = URI("http://localhost:3000/movie_credits")



    ## 입력한 movie_id를 기반으로 Movie CRAWL 하는 작업 진행

    # TMDB API에 Movie data get 요청
    movie = getDataFromApi(tmdb_api_uri_movie)

    # status_code가 34면 리소스 존재하지 않음으로 건너 뜀
    if movie['status_code'] == 34
        puts "[ERROR   ] The MOVIE##{movie_id} could not be found."
    
    # 리소스 존재한다면 CRAWL 작업 진행
    else
        # 받아온 Data를 이용하여 Movie 생성
        movie = {
            'movie_id'=>movie_id,
            'title'=>movie['title'],
            'rating'=>movie['vote_average'],
            'overview'=>movie['overview'],
            'poster_path'=>movie['poster_path']
        }

        # LOCAL SERVER로 Movie data post 요청
        response = postDataToServer(local_server_uri_movie, movie)    
        if response.code == '200'
            puts JSON.parse(response.body)["message"]
        else
            puts "[ERROR   ] The MOVIE##{movie_id} is aleady created value."
        end



        ## 생성된 Movie의 cast, crew를 기반으로 Person, MovieCredit CRAWL 하는 작업 진행

        # TMDB API에 MovieCredit data get 요청
        credits = getDataFromApi(tmdb_api_uri_movie_credit)

        # 받아온 Data의 cast 정보에 존재하는 모든 Person 생성
        casts = credits['cast']

        # 너무 많은 person 생성으로 인해 크롤 시간이 오래 걸리고, DB 조회시 가독성이 떨어지므로 각 영화당 5개만 생성
        if casts.length > 5
            casts = casts[1..5]
        end

        casts.each do |cast|
  
            # cast 의 id 값을 이용하여 Person data get 요청 (누락되는 정보들 존재해서 person uri로 다시 요청)
            tmdb_api_uri_person = URI("https://api.themoviedb.org/3/person/#{cast['id']}?api_key=#{$tmdb_api_key}")
            person = getDataFromApi(tmdb_api_uri_person)

            # Person 생성
            person = {
                'person_id'=>person['id'],
                'name'=>person['name'],
                'job'=>person['known_for_department'],
                'birthday'=>person['birthday'],
                'biography'=>person['biography'],
                'profile_path'=>person['profile_path']
            }
 
            # LOCAL SERVER로 Person data post 요청
            response = postDataToServer(local_server_uri_person, person)
            if response.code == '200'
                puts JSON.parse(response.body)["message"]
            else
                puts "[ERROR   ] The PERSON##{person['person_id']} is aleady created value."
            end

            # Movie와 Person 사이의 관계를 의미하는 MovieCredit 생성
            movie_credit = {
                'movie_id'=>movie_id,
                'person_id'=>person['person_id'],
                'role'=>'cast'
            }

            # LOCAL SERVER로 MovieCredit data post 요청
            response = postDataToServer(local_server_uri_movie_credit, movie_credit)
            if response.code == '200'
                puts JSON.parse(response.body)["message"]
            else
                puts "[ERROR   ] The MOVIE_CREDIT##{movie_credit['movie_id']}-#{movie_credit['person_id']} aleady created value."
            end
        end

        # 받아온 Data의 crew 정보에 존재하는 모든 Person 생성
        crews = credits['crew']

        # 너무 많은 person 생성으로 인해 크롤 시간이 오래 걸리고, DB 조회시 가독성이 떨어지므로 각 영화당 5개만 생성
        if crews.length > 5
            crews = crews[1..5]
        end

        crews.each do |crew|

             # crew 의 id 값을 이용하여 Person data get 요청 (누락되는 정보들 존재해서 person uri로 다시 요청)
            tmdb_api_uri_person = URI("https://api.themoviedb.org/3/person/#{crew['id']}?api_key=#{$tmdb_api_key}")
            person = getDataFromApi(tmdb_api_uri_person)

            # Person 생성
            person = {
                'person_id'=>person['id'],
                'name'=>person['name'],
                'job'=>person['known_for_department'],
                'birthday'=>person['birthday'],
                'biography'=>person['biography'],
                'profile_path'=>person['profile_path']
            }
            
            # LOCAL SERVER로 Person data post 요청
            response = postDataToServer(local_server_uri_person, person)
            if response.code == '200'
                puts JSON.parse(response.body)["message"]
            else
                puts "[ERROR   ] The PERSON##{person['person_id']} is aleady created value."
            end

            # Movie와 Person 사이의 관계를 의미하는 MovieCredit 생성
            movie_credit = {
                'movie_id'=>movie_id,
                'person_id'=>person['person_id'],
                'role'=>'crew'
            }

            # LOCAL SERVER로 MovieCredit data post 요청
            response = postDataToServer(local_server_uri_movie_credit, movie_credit)
            if response.code == '200'
                puts JSON.parse(response.body)["message"]
            else
                puts "[ERROR   ] The MOVIE_CREDIT##{movie_credit['movie_id']}-#{movie_credit['person_id']} aleady created value."
            end
        end
    end
end
