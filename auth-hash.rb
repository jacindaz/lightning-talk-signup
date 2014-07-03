session = {"session_id"=>"967501e0cb64cb5c425f9932477b69ce813fdafa80739b6a01ed77843b76d50d",
          "csrf"=>"c145238a4e3d958c8c7c8ef26cad1161",
          "tracking"=>{
            "HTTP_USER_AGENT"=>"9637f8f4698bacb96d868e6d21c5775564123002",
            "HTTP_ACCEPT_LANGUAGE"=>"66eae971492938c2dcc2fb1ddc8d7ec3196037da"},
          "flash"=>{},
          "__FLASH__"=>{
              :notice=>"I'm sorry, your talk could not be saved."},
          "one"=>{}}
=>{"provider"=>"github",
 "uid"=>"6325129",
 "info"=>
  {"nickname"=>"jacindaz",
   "email"=>"",
   "name"=>"Jacinda Zhong",
   "image"=>"https://avatars.githubusercontent.com/u/6325129?",
   "urls"=>
    {"GitHub"=>"https://github.com/jacindaz",
     "Blog"=>"www.linkedin.com/in/jacindazhong/"}},
 "credentials"=>
=> {"provider"=>"github",
 "uid"=>"6325129",
 "info"=>
  {"nickname"=>"jacindaz",
   "email"=>"",
   "name"=>"Jacinda Zhong",
   "image"=>"https://avatars.githubusercontent.com/u/6325129?",
   "urls"=>
    {"GitHub"=>"https://github.com/jacindaz",
     "Blog"=>"www.linkedin.com/in/jacindazhong/"}},
 "credentials"=>
  {"token"=>"8c42d57c4ec77588bd3a2a2244cbbc946edeb361", "expires"=>false},
 "extra"=>
  {"raw_info"=>
    {"login"=>"jacindaz",
     "id"=>6325129,
     "avatar_url"=>"https://avatars.githubusercontent.com/u/6325129?",
     "gravatar_id"=>"3a61d0e9a98c838c970b4237784c47e5",
     "url"=>"https://api.github.com/users/jacindaz",
     "html_url"=>"https://github.com/jacindaz",
     "followers_url"=>"https://api.github.com/users/jacindaz/followers",
     "following_url"=>
      "https://api.github.com/users/jacindaz/following{/other_user}",
     "gists_url"=>"https://api.github.com/users/jacindaz/gists{/gist_id}",
     "starred_url"=>
      "https://api.github.com/users/jacindaz/starred{/owner}{/repo}",
     "subscriptions_url"=>
      "https://api.github.com/users/jacindaz/subscriptions",
     "organizations_url"=>"https://api.github.com/users/jacindaz/orgs",
     "repos_url"=>"https://api.github.com/users/jacindaz/repos",
     "events_url"=>"https://api.github.com/users/jacindaz/events{/privacy}",
     "received_events_url"=>
      "https://api.github.com/users/jacindaz/received_events",
     "type"=>"User",
     "site_admin"=>false,
     "name"=>"Jacinda Zhong",
     "company"=>"Launch Academy - Ruby on Rails Scholar",
     "blog"=>"www.linkedin.com/in/jacindazhong/",
     "location"=>"Cambridge, MA",
     "email"=>"",
     "hireable"=>true,
     "bio"=>nil,
     "public_repos"=>39,
     "public_gists"=>13,
     "followers"=>12,
     "following"=>30,
     "created_at"=>"2014-01-05T21:20:53Z",
     "updated_at"=>"2014-07-03T12:05:29Z"}}}



puts "#{session['extra']['raw_info']['company']}"
