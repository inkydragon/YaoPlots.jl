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



#=
- [Yao.jl/BlockBasics.jl at 6af3ba2160181e592d0a0b66f14af489f4959c57 · QuantumBFS/Yao.jl](https://github.com/QuantumBFS/Yao.jl/blob/6af3ba2160181e592d0a0b66f14af489f4959c57/docs/src/tutorial/BlockBasics.jl#L75-L84)
=#

using InteractiveUtils: subtypes
function subtypetree(t, level=1, indent=4)
   level == 1 && println(t)
   for s in subtypes(t)
     println(join(fill(" ", level * indent)) * string(s))
     subtypetree(s, level+1, indent)
   end
end

subtypetree(Yao.Blocks.AbstractBlock);
#=
AbstractBlock
    AbstractMeasure
        Measure
        MeasureAndRemove
        MeasureAndReset
    FunctionBlock
    MatrixBlock
        AbstractContainer
            Concentrator
            ControlBlock
            PutBlock
            RepeatedBlock
            TagBlock
                AbstractDiff
                    BPDiff
                    QDiff
                AbstractScale
                    Scale
                    StaticScale
                CachedBlock
                Daggered
        CompositeBlock
            AddBlock
            ChainBlock
            KronBlock
            PauliString
            Roller
        PrimitiveBlock
            ConstantGate
                CNOTGate
                HGate
                I2Gate
                P0Gate
                P1Gate
                PdGate
                PuGate
                SGate
                SWAPGate
                SdagGate
                TGate
                TdagGate
                ToffoliGate
                XGate
                YGate
                ZGate
            GeneralMatrixGate
            MathBlock
            PhaseGate
            ReflectBlock
            RotationGate
            ShiftGate
            Swap
            TimeEvolution
    Sequential
=#
