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
  case NewGreeting:save() of
    {ok, SavedGreeting} ->
      {redirect, [{action, "list"}]};
    {error, ErrorList} ->
      {ok, [{errors, ErrorList}, {new_msg, NewGreeting}]}
  end.
goodbye('POST', []) ->
  boss_db:delete(Req:post_param("greeting_id")),
  {redirect, [{action, "list"}]}.
send_test_message('GET', []) ->
  TestMessage = "Free at last!",
  boss_mq:push("test-channel", TestMessage),
  {output, TestMessage}.
