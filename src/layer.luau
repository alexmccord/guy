--!strict
local Matrix = require("./src/matrix")
type Matrix<T> = Matrix.Matrix<T>

export type Neuron = number

export type Layer = {
    neurons: {Neuron},
    weights: Matrix<number>?,
    prev: Layer?,
    next: Layer?,
}

local Layer = {}

function Layer.new(prev: Layer?, neuronCount: number)
    local layer: Layer = {
        neurons = table.create(neuronCount, 0),
        weights = nil,
        prev = prev,
        next = nil,
    }

    if prev ~= nil then
        prev.next = layer

        local weights = Matrix.new(#prev.neurons, neuronCount)
        layer.weights = weights

        for i = 1, #prev.neurons * neuronCount do
            Matrix.insert(weights, 1)
        end
    end

    return layer
end

function Layer.update(layer: Layer, activations: {Neuron})
    layer.neurons = Layer.mul(layer, activations)

    if layer.next then
        Layer.update(layer.next, layer.neurons)
    end
end

function Layer.mul(layer: Layer, neurons: {Neuron}): {Neuron}
    assert(layer.weights ~= nil, "Layer.mul should not be called on an input layer")

    return Matrix.mul(layer.weights, neurons)
end

return Layer
