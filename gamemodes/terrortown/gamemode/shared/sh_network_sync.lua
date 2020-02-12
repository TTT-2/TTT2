---
-- This file contains all shared networking functions, to sync and manage the information between server and clients
-- @author saibotk

TTT2NET = {}

-- Network message name constants
TTT2NET.NETMSG_META_UPDATE = "TTT2_NET_META_UPDATE"
TTT2NET.NETMSG_DATA_UPDATE = "TTT2_NET_DATA_UPDATE"
TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE = "TTT2_NET_REQUEST_FULL_STATE_UPDATE"

-- Network stream message name constants
TTT2NET.NET_STREAM_FULL_STATE_UPDATE = "TTT2_NET_STREAM_FULL_STATE_UPDATE"
