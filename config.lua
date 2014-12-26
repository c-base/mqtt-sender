server   = "c-beam.cbrp3.c-base.org"
port     = 1883
id       = "mqtt_" .. hostname
presence = "client/" .. hostname
prefix   = "system/" .. hostname .. "/"

topic_add(topics, "traffic", 60, { ["eth0"] = "lan"; })
--topic_add(topics, "traffic", 60, { ["i-ipb"] = "ipb"; ["i-kdg"] = "kdg"; })
