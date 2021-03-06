local radio = require('radio')

if #arg < 1 then
    io.stderr:write("Usage: " .. arg[0] .. " <FM radio frequency>\n")
    os.exit(1)
end

local frequency = tonumber(arg[1])
local tune_offset = -250e3

-- Blocks
local source = radio.RtlSdrSource(frequency + tune_offset, 1102500)
local tuner = radio.TunerBlock(tune_offset, 200e3, 5)
local fm_demod = radio.FrequencyDiscriminatorBlock(1.25)
local af_filter = radio.LowpassFilterBlock(128, 15e3)
local af_deemphasis = radio.FMDeemphasisFilterBlock(75e-6)
local af_downsampler = radio.DownsamplerBlock(5)
local sink = radio.PulseAudioSink(1)

-- Connections
local top = radio.CompositeBlock()
top:connect(source, tuner, fm_demod, af_filter, af_deemphasis, af_downsampler, sink)
top:run()
