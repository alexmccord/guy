--!strict
local guy = require("./src/network")
local Layer = require("./src/layer")

local myNetwork = guy.new()
    :addLayer(28 * 28)
    :addLayer(16)
    :addLayer(16)
    :addLayer(10)
    :build()

local function inspect(name: string, layer: Layer.Layer, row: number)
    print(name)
    print(string.rep("-", #name))
    local s = ""
    for i, n in layer.neurons do
        s ..= `{string.format("%05d", n)} `
        if i % row == 0 then
            print(s)
            s = ""
        end
    end
end

local function dump(name: string, layer: Layer.Layer, row: number)
    print(name)
    print(string.rep("-", #name))
    for i, v in layer.neurons do
        print(`{i}: {v}`)
    end
end

local function update(layer: Layer.Layer, activations: {Layer.Neuron})
    layer.neurons = activations
    assert(layer.next)
    Layer.update(layer.next, activations)
end

inspect("input", myNetwork.input, 28)
inspect("output", myNetwork.output, 10)
update(myNetwork.input, myNetwork.input.neurons)
inspect("input", myNetwork.input, 28)
inspect("output", myNetwork.output, 10)
update(myNetwork.input, table.create(28*28, 1))
inspect("input", myNetwork.input, 28)
inspect("output", myNetwork.output, 10)
