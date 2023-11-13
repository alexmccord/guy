--!strict
local Layer = require("./src/layer")
type Layer = Layer.Layer
type Neuron = Layer.Neuron

local Matrix = require("./src/matrix")
type Matrix<T> = Matrix.Matrix<T>

export type NeuralNetwork = {
    input: Layer,
    output: Layer,
}

export type NeuralNetworkBuilder<S = {}> = S & {
    addLayer: (self: NeuralNetworkBuilder<S>, neuronCount: number) -> NeuralNetworkBuilder<S>,
    build: (self: NeuralNetworkBuilder<S>) -> NeuralNetwork,
}

local NeuralNetworkBuilder = {}

function NeuralNetworkBuilder.new(): NeuralNetworkBuilder
    type LayerInfo = { neuronCount: number }
    local builder = {} :: NeuralNetworkBuilder<{ layers: {LayerInfo} }>
    builder.layers = {}

    function builder:addLayer(neuronCount)
        table.insert(self.layers, { neuronCount = neuronCount })
        return self
    end

    function builder:build()
        assert(#self.layers ~= 0, "addLayer was never called")
        assert(#self.layers ~= 1, "addLayer was only called once")

        local first = nil
        local current = nil

        for i, l in self.layers do
            local layer = Layer.new(current, l.neuronCount)

            first = first or layer
            current = layer
        end

        return { input = first, output = current :: Layer }
    end

    return builder
end

return NeuralNetworkBuilder
