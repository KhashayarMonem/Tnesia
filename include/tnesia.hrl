-record(tnesia_input, {id, timestamp, record}).
-record(tnesia_base, {base_key, base_val}).
-record(tnesia_bag, {bag_key, base_key}).
-record(tnesia_sample, {foo, bar, bat}).
-record(tnesia_query, {
   bag :: any(),
   from :: integer(),
   to :: integer(),
   limit = 50 :: integer(),
   return :: true | false,
   order = asc :: asc | des
}).
