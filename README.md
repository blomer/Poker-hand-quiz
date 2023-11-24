Typical CRUD app
----------------

stateful widget
 - int counter

on init () 
   - async GET /counter 
   - counter = result.counter

on button press 
set state (API call to POST /counter
  counter = result.counter
)
set state (API call to POST /counter

database
--------
counter : 12
-------


Event sourcing
---------------

stateful widget
- int counter

on init ()
- async GET /counter
- counter = result.counter

on button press
event(type=counter_increase)
event(type=counter_decrease)

set state (API call to POST /counter


database
--------
table events
event_id | data
-------
1, {counter_increase}
2, {counter_increase}
3, {counter_decrease}
------
counter = 1

events
state_machine

e1, null -> state_machine -> s1
e2, s1 -> state_machine ->  s2

------------



cof_app -> flutter app
cof_engine -> common code

()
event:
    - type = bet
    - amount = 1
    - player = p1
Protobuf(machine format) 23q7869hn;laxs923414908
S1.apply(e1) -> S2
 


cof_server -> backend game server
23q7869hn;laxs923414908 ->
event:
    - type = bet
  - amount = 1
  - player = p1

S1.apply(e1) => S2






