hl.monitor({ 
    output = "DP-2",
    mode = "2560x1440@144",
    position = "0x0",
    scale = 1 
})
hl.monitor({ 
    output = "DP-1",
    mode = "2560x1440@240",
    position = "2560x0",
    scale = 1,
    bitdepth = 10,
    -- cm = "hdr",
    cm = "srgb",
    sdrbrightness = 1.,
    vrr = 2 
})
