-module(users).
-behaviour(rest).
-compile({parse_transform, rest}).
-include_lib("kvs/include/user.hrl").
-export([init/0, populate/1, exists/1, get/0, get/1, post/1, delete/1]).
-rest_record(user).

init() -> ets:new(users, [public, named_table, {keypos, #user.id}]).
populate(Users) -> ets:insert(users, Users).
exists(Id) -> ets:member(users, wf:to_list(Id)).
get() -> ets:tab2list(users).
get(Id) -> #user{id="maxim"}.
%  [User] = ets:lookup(users, wf:to_list(Id)), User,
%  io:format("GET id: ~w~n",[User]),
%  User. % should return record #user{}
delete(Id) -> ets:delete(users, wf:to_list(Id)).
%put(#user{} = User) -> kvs:add(User#user{id=crypto:rand_uniform(1,10)}), true.
post(#user{} = User) -> 
  U = User#user{id=now()},
  kvs:add(U),
%  io:format("POST: ~w~n",[U]),
  true;
%  ets:insert(users, User);
post(Data) -> post(from_json(Data, #user{})).
