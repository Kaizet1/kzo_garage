Config = {}
Config.Blip = {
	['default'] = {
		Spire = 357,
		Scale = 0.8,
		Color = 3,
	}
}
Config.ImpoundPay = 3000 -- Impound fee
Config.HelpNotification = {
	["GaragePoint"] = "Press [E] to access garage",
	["DeletePoint"] = "Press [E] to store vehicle"
}
Config.Jobs = {
	["police"] = true,
	["mechanic"] = true,
	["ambulance"] = true,
}
Config.Garages = {
	--Job
	['GarageAmbulance'] = {
		Type = "all",  -- Vehicle type
		Job = "ambulance",
		GaragePoint = { x = 297.73, y = -602.03, z = 43.3 },
		SpawnPoint = { x = 289.91, y = -608.85, z = 43.35, h = 65.27 },
		DeletePoint = { x = 289.4, y = -613.21, z = 43.41 }
	},
	['GarageMechanic'] = {
		Type = "all",
		Job = "mechanic",
		GaragePoint = { x = 1019.0, y = -2280.89, z = 30.56 },
		SpawnPoint = { x = 1046.28, y = -2298.44, z = 30.54, h = 169.07 },
		DeletePoint = { x = 1032.73, y = -2270.51, z = 30.51 }
	},
	['GaragePolice'] = {
		Type = "all",
		Blip = false,
		Job = "police",
		GaragePoint = { x = 441.92, y = -1013.57, z = 28.63 },
		SpawnPoint = { x = 427.71, y = -1020.94, z = 28.92, h = 83.95 },
		DeletePoint = { x = 442.6, y = -1021.4, z = 28.26 }
	},
	['GarageGanghouse1'] = {
		Type = "all",
		Blip = false,
		-- Job = "police",
		GaragePoint = { x = 1373.863, y = 1137.407, z = 114.0289 },
		SpawnPoint = { x = 1368.938, y = 1137.346, z = 113.7588, h = 40.88071},
		DeletePoint = { x = 1361.007, y = 1161.098, z = 113.7496}
	},
	['GarageGanghouse2'] = {
		Type = "car",
		Blip = false,
		GaragePoint = { x = -2671.163, y = 1305.013, z = 147.1185 },
		SpawnPoint = { x = -2661.371, y = 1307.173, z = 147.1185, h = 276.209},
		DeletePoint = { x = -2671.544, y = 1309.808, z = 147.1185}
	},
	['Garage9148'] = {
		Type = "car",
		GaragePoint = { x = 404.07, y = -1625.98, z = 29.29 },
		SpawnPoint = { x = 412.21, y = -1649.84, z = 29.29, h = 228.55 },
		DeletePoint = { x = 400.65, y = -1633.12, z = 29.29 }
	},

	['GarageCentralLS'] = {
		Type = "car",
		GaragePoint = { x = 215.6745300293, y = -809.82214355469, z = 30.734027862549 },
		SpawnPoint = { x = 229.700, y = -800.1149, z = 29.5722, h = 157.84 },
		DeletePoint = { x = 216.62, y = -785.57, z = 30.30 }
	},
	['GarageSandy'] = {
		Type = "car",
		GaragePoint = { x = 1737.1572265625, y = 3712.3679199219, z = 34.124103546143 },
		SpawnPoint = { x = 1737.84, y = 3719.28, z = 33.04, h = 21.22 },
		DeletePoint = { x = 1722.66, y = 3713.74, z = 33.21 }
	},
	['GaragePaleto'] = {
		Type = "car",
		GaragePoint = { x = 105.359, y = 6613.586, z = 32.3973 },
		SpawnPoint = { x = 128.7822, y = 6622.9965, z = 31.7828, h = 315.01 },
		DeletePoint = { x = 126.3572, y = 6608.4150, z = 31.8565 }
	},
	['GaragePrison'] = {
		Type = "car",
		GaragePoint = { x = 1834.3353271484, y = 2542.107421875, z = 46.880611419678-0.9 },
		SpawnPoint = { x = 1872.0330810547, y = 2601.0649414063, z = 45.672016143799, h = 270.69500732422 },
		DeletePoint = { x = 1844.1782226563, y = 2529.1552734375, z = 45.672054290771 }
	},
	['GarageCarCasino'] = {
		Type = "car",
		GaragePoint = { x = 853.53, y = -47.76, z = 79.76-0.9 },
		SpawnPoint = { x = 861.96, y = -38.93, z = 79.76-0.9, h = 326.28 },
		DeletePoint = { x = 855.97, y = -34.59, z = 79.67-0.9 }
	},
	['Garage Gangster'] = {
		Type = "car",
		GaragePoint = { x = -2968.7150878906, y = 370.93441772461, z = 15.770765304565-0.9 },
		SpawnPoint = { x = -2971.0349121094, y = 361.41516113281, z = 15.772721290588, h = 159.9508972168 },
		DeletePoint = { x = -2961.8752441406, y = 368.13061523438, z = 15.770541191101-0.9 }
	},
	['GarageLSIA'] = {
		Type = "car",
		GaragePoint = { x = -1046.9467773438, y = -2721.03125, z = 13.756636619568 },
		SpawnPoint = { x = -1046.1053466797, y = -2716.015625, z = 13.670547485352, h = 232.4306640625 },
		DeletePoint = { x = -1046.1053466797, y = -2716.015625, z = 13.670547485352 }
	},
	['GarageJobCenter'] = {
		Type = "car",
		GaragePoint = { x = -297.42813110352, y = -989.18603515625, z = 31.080617904663 },
		SpawnPoint = { x = -299.67260742188, y = -980.83703613281, z = 31.08062171936, h = 248.23406982422 },
		DeletePoint = { x = -317.98867797852, y = -983.03485107422, z = 31.080614089966 }
	},
	['GarageJobCente2r'] = {
		Type = "car",
		GaragePoint = { x = -1513.1607666016, y = -437.17446899414, z = 35.44206237793 },
		SpawnPoint = { x = -1525.4644775391, y = -435.70822143555, z = 35.442115783691, h = 211.64083862305 },
		DeletePoint = { x = -1517.3094482422, y = -423.54006958008, z = 35.442192077637 }
	},
	['GarageJobCente22r'] = {
		Type = "car",
		GaragePoint = { x = 442.9182434082, y = -1969.0135498047, z = 24.401731491089 },
		SpawnPoint = { x = 448.50970458984, y = -1966.6499023438, z = 22.933994293213, h = 220.43521118164 },
		DeletePoint = { x = 437.26779174805, y = -1956.6663818359, z = 23.057361602783	}
	},

	['GarageBay1'] = {
		Type = "plane",
		BlipText = "Plane Garage",
		GaragePoint = { x = -995.7, y = -2945.98, z = 13.96 },
		SpawnPoint = { x = -1112.53, y = -2884.51, z = 13.95, h = 153.0 },
		DeletePoint = { x = -1034.87, y = -2974.26, z = 13.95	}
	},
	['GarageBay2'] = {
		Type = "plane",
		BlipText = "Plane Garage",
		GaragePoint = { x = 1728.85, y = 3290.33, z = 41.17 },
		SpawnPoint = { x = 1716.25, y = 3256.9, z = 41.13, h = 104.92 },
		DeletePoint = { x = 1743.56, y = 3266.45, z = 41.24	}
	},
	['GarageBay3'] = {
		Type = "plane",
		BlipText = "Plane Garage",
		GaragePoint = { x = 4455.17, y = -4477.17, z = 4.28 },
		SpawnPoint = { x = 4464.01, y = -4500.98, z = 4.19, h = 110.43 },
		DeletePoint = { x = 4428.49, y = -4494.81, z = 4.21	}
	},
}