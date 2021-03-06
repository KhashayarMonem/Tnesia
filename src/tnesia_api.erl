-module(tnesia_api).

-export([
	 write/2,
	 read/2,
	 remove/2,
	 query_fetch/1,
	 query_filtermap/2,
	 query_foreach/2,
	 query_raw/3
	]).

-include("tnesia.hrl").

%%====================================================================
%% Main API
%%====================================================================

%%--------------------------------------------------------------------
%% write
%%--------------------------------------------------------------------
write(Timeline, Record) ->
    Timepoint = tnesia_lib:write(
	      #tnesia_input{
		 timeline = Timeline,
		 timepoint = now(),
		 record = Record}),
    {Timeline, Timepoint}.

%%--------------------------------------------------------------------
%% read
%%--------------------------------------------------------------------
read(Timeline, Timepoint) ->
    tnesia_lib:read_timepoint(Timeline, Timepoint).

%%--------------------------------------------------------------------
%% remove
%%--------------------------------------------------------------------
remove(Timeline, Timepoint) ->
    tnesia_lib:remove_timepoint(Timeline, Timepoint).

%%--------------------------------------------------------------------
%% query_fetch
%%--------------------------------------------------------------------
query_fetch(Query) ->
    query_filtermap(
      Query, 
      fun(BaseRecord, _BagRecord, _Limit) -> {true, BaseRecord} end
     ).
%%--------------------------------------------------------------------
%% query_filtermap
%%--------------------------------------------------------------------
query_filtermap(Query, Fun) ->
    query_raw(Query, true, Fun).

%%--------------------------------------------------------------------
%% query_foreach
%%--------------------------------------------------------------------
query_foreach(Query, Fun) ->
    [] = query_raw(Query, false, Fun),
    ok.

%%--------------------------------------------------------------------
%% query_raw
%%--------------------------------------------------------------------
query_raw(Query, Return, Fun) ->

    Timeline = proplists:get_value(timeline, Query, tnesia_lib:default_timeline()),
    Since = proplists:get_value(since, Query, tnesia_lib:default_since()),
    Till = proplists:get_value(till, Query, tnesia_lib:default_till()),
    Order = proplists:get_value(order, Query, tnesia_lib:default_order()),
    Limit = proplists:get_value(limit, Query, tnesia_lib:default_limit()),

    tnesia_lib:init_read_since_till(
      #tnesia_query{
	 bag = Timeline,
	 from = Since,
	 to = Till,
	 limit = Limit,
	 order = Order,
	 return = Return
	},
      Fun).
