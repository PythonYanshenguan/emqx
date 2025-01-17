-module(emqx_bridge_mqtt_schema).

-include_lib("typerefl/include/types.hrl").

-import(hoconsc, [mk/2]).

-export([roots/0, fields/1]).

%%======================================================================================
%% Hocon Schema Definitions
roots() -> [].

fields("ingress") ->
    [ emqx_bridge_schema:direction_field(ingress, emqx_connector_mqtt_schema:ingress_desc())
    ]
    ++ emqx_bridge_schema:common_bridge_fields()
    ++ proplists:delete(hookpoint, emqx_connector_mqtt_schema:fields("ingress"));

fields("egress") ->
    [ emqx_bridge_schema:direction_field(egress, emqx_connector_mqtt_schema:egress_desc())
    ]
    ++ emqx_bridge_schema:common_bridge_fields()
    ++ emqx_connector_mqtt_schema:fields("egress");

fields("post_ingress") ->
    [ type_field()
    ] ++ proplists:delete(enable, fields("ingress"));
fields("post_egress") ->
    [ type_field()
    ] ++ proplists:delete(enable, fields("egress"));

fields("put_ingress") ->
    proplists:delete(enable, fields("ingress"));
fields("put_egress") ->
    proplists:delete(enable, fields("egress"));

fields("get_ingress") ->
    [ id_field()
    ] ++ emqx_bridge_schema:metrics_status_fields() ++ fields("post_ingress");
fields("get_egress") ->
    [ id_field()
    ] ++ emqx_bridge_schema:metrics_status_fields() ++ fields("post_egress").

%%======================================================================================
id_field() ->
    {id, mk(binary(), #{desc => "The bridge ID", example => "mqtt:my_mqtt_bridge"})}.

type_field() ->
    {type, mk(mqtt, #{desc => "The bridge type"})}.
