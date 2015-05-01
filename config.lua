-- server   = "c-beam.cbrp3.c-base.org"
server   = "10.0.1.17"
port     = 1883

presence = "client/" .. hostname
prefix   = "system/" .. hostname .. "/"

--topic_add(topics, "traffic", 60, { ["eth0"] = "lan"; })
--topic_add(topics, "traffic", 60, { ["i-ipb"] = "ipb"; ["i-kdg"] = "kdg"; })
--topic_add(topics, "cpu", 300, { })
subscription_add(subscriptions, "mod_ampel", "ampel/nerd", {["pins"] = {["green"] = "14", ["red"] = "15"}})