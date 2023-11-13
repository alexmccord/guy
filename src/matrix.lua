--!strict
export type Matrix<T> = {
    row: number,
    col: number,
    nodes: {T},
}

local Matrix = {}

function Matrix.new<T>(row: number, col: number): Matrix<T>
    return {
        row = row,
        col = col,
        nodes = table.create(row * col),
    }
end

function Matrix.pos<T>(mat: Matrix<T>, row: number, col: number)
    assert(row >= 1, `row should be greater than 0, but got {row}`)
    assert(col >= 1, `col should be greater than 0, but got {col}`)
    return (row - 1) * mat.col + col
end

function Matrix.at<T>(mat: Matrix<T>, row: number, col: number)
    local result = mat.nodes[Matrix.pos(mat, row, col)]
    assert(result ~= nil, `Got nil value at ({row}, {col})`)
    return result
end

function Matrix.insert<T>(mat: Matrix<T>, value: T)
    table.insert(mat.nodes, value)
end

function Matrix.update<T>(mat: Matrix<T>, row: number, col: number, value: T)
    mat.nodes[Matrix.pos(mat, row, col)] = value
end

function Matrix.mul<T, U>(mat: Matrix<T>, vec: {U})
    local result = table.create(#vec)
    for i = 1, mat.col do
        table.insert(result, (Matrix.at(mat, i, i) :: any) * (vec[i] :: any))
    end
    return result
end

return Matrix
