using Yao, Yao.Blocks
using LinearAlgebra

circuit(n) = chain(
    n,
    put(1=>X),
    repeat(H, 2:n),
    control(2, 1=>X),
    control(4, 3=>X),
    control(3, 1=>X),
    control(4, 3=>X),
    repeat(H, 1:n),
)

cc = circuit(4)

number_of_bits = nqubits(cc)

## root block
typeof(cc) 
# PutBlock{4,1,XGate{Complex{Float64}},Complex{Float64}}
typeof(cc[1]).types
# svec(XGate{Complex{Float64}}, Tuple{Int64})
typeof(cc[1]).name
# PutBlock
typeof(cc[1]).parameters
# svec(4, 1, XGate{Complex{Float64}}, Complex{Float64})

