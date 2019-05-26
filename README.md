# rails-tmdb

<미리보기 이미지>

TMDB를 이용하여 Movie, Tv, Person DB를 구축하고 간단한 웹페이지를 통해 Data의 CRUD를 서비스

<br/>
<br/>

## *Introduction*


### Description
> - Movie, Tv, Person 을 Database에 저장할 수 있도록 Schema를 설계하고 TMDB의 정보를 이용하여 DB를 구축 
> 
> - Data를 만들기 위해 TMDB API에 GET 요청을 통해 data를 Crawling 하며, Ruby 스크립트를 이용하여 Movie, Tv, Person 정보를 수집 
>
> - Ruby on Rails 프레임워크를 이용하여 간단한 웹페이지를 구축하며, 웹 페이지의 유저 인터페이스를 이용하여 DB에 저장된 Data의 CRUD 서비스를 제공
> 
> - 서버는 REST하게 설계되었기 때문에 HTTP 의 메소드를 이용한 CRUD 서비스도 가능


### Requirements
> - [RVM](https://rvm.io/)
> - [Ruby 2.5.3](https://www.ruby-lang.org/en/news/2018/10/18/ruby-2-5-3-released/) 
> - [Bundler 2.0.1](https://rubygems.org/gems/bundler/versions/2.0.1)
> - [Rails 5.2.3](https://rubygems.org/gems/rails/versions/5.2.3)
> - [MySQL 5.6](https://dev.mysql.com/downloads/mysql/5.6.html)


### End-points

> **Resource Modeling :**
> 
> - [RoR 개발 가이드 문서](https://guides.rorlab.org/routing.html)를 참조하여 RESTful하게 리소스를 모델링
> - 모든 리소스 (Movie, Tv, Person, MovieCredit, TvCredit) 들은 다음과 같은 모델링 원칙을 준수
> 
> |  HTTP |  Path |  Controller#action |  목적 |
> | --- | --- | --- | --- |
> |**GET** |/movies|movie#index|모든 Movie 표시|
> |**GET** |/movies/new|movie#new|Movie 작성용 양식을 반환|
> |**GET** |/movies/:movie_id|movie#show|하나의 Movie 표시|
> |**POST** |/movies|movie#create|하나의 Movie 생성|
> |**GET** |/movies/:movie_id/edit|movie#edit|Movie 작성용 양식을 반환|
> |**PUT** |/movies/:movie_id|movie#update|하나의 Movie 수정|
> |**DELETE** |/movies/:movie_id|movie#destroy|하나의 Movie 삭제|
> 
> **Route :**
> 
> - `config/routes.rb`
> ```ruby
> Rails.application.routes.draw do
> 
>   # Home endpoint
>   root 'home#index'
>   get 'home/index' => 'home#index'
> 
>   # Movies CRUD endpoints
>   get 'movies' => 'movie#index'
>   get 'movies/new' => 'movie#new'
>   get 'movies/:movie_id' => 'movie#show'
>   post '/movies' => 'movie#create'
>   get 'movies/:movie_id/edit' => 'movie#edit'
>   put 'movies/:movie_id' => 'movie#update'
>   delete 'movies/:movie_id' => 'movie#destroy'
> 
>   # Tvs CRUD endpoints
>   get 'tvs' => 'tv#index'
>   get 'tvs/new' => 'tv#new'
>   get 'tvs/:tv_id' => 'tv#show'
>   post '/tvs' => 'tv#create'
>   get 'tvs/:tv_id/edit' => 'tv#edit'
>   put 'tvs/:tv_id' => 'tv#update'
>   delete 'tvs/:tv_id' => 'tv#destroy'
> 
>   # People CRUD endpoints
>   get 'people' => 'person#index'
>   get 'people/new' => 'person#new'
>   get 'people/:person_id' => 'person#show'
>   post '/people' => 'person#create'
>   get 'people/:person_id/edit' => 'person#edit'
>   put 'people/:person_id' => 'person#update'
>   delete 'people/:person_id' => 'person#destroy'
> 
> end
> 
> ```

### Database Schema
> 
> <img src="./app/assets/images/data-schema.jpg" alt="database-schema"/>


### Service Flow
> 
> <img src="./app/assets/images/system-flow.jpg" alt="system-flow"/>


<br/>
<br/>

## *Installation*

### 1. Configure  db connection

- `config/database.yml`
- username, password 입력

```diff
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
+  username: YOUR_USERNAME
+  password: YOUR_PASSWORD
  host: 127.0.0.1
  socket: /tmp/mysql.sock

development:
  <<: *default
  database: tmdb_development

test:
  <<: *default
  database: tmdb_test
```

- `lib/crawl_movie.rb`, `lib/crawl_tv.rb`
-  $tmdb_api_key 입력

```ruby
#!/usr/bin/env ruby
require 'net/http'
require 'json'

# TMDB API KEY 셋팅
$tmdb_api_key = YOUR_TMDB_API_KEY

# TMDB API에 GET 요청 전송하는 함수
def getDataFromApi(uri)
    return JSON.parse(Net::HTTP.get(uri))
end
```

### 2. Bundle install 

- `shell command` 프로젝트 루트 위치에서 입력
```bash
$ bundle install
```

### 3. Setup database

- `shell command` 프로젝트 루트 위치에서 입력
```bash
$ rake db:create
$ rake db:migrate
```



