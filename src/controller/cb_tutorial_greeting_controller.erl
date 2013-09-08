-module(cb_tutorial_greeting_controller, [Req]).
-compile(export_all).
hello('GET', []) ->
  {ok, [{greeting, "Hello, world!"}]}.
list('GET', []) ->
  Greetings = boss_db:find(greeting, []),
  {ok, [{greetings, Greetings}]}.
create('GET', []) ->
  ok;
create('POST', []) ->
  GreetingText = Req:post_param("greeting_text"),
  NewGreeting = greeting:new(id, GreetingText),
  {ok, SavedGreeting} = NewGreeting:save(),
  {redirect, [{action, "list"}]}.
