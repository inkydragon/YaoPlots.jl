using Luxor

#=
Gate ref: Quantum Circuit Diagrams in LATEX\P11\3.2 Gates
=#

#=
    constant
=#
const GateSpacing = 30
const LineSpacing = 40
const ΔX = Point(GateSpacing, 0)
const ΔY = Point(0, LineSpacing)

#= 
    help function 
=#

"""
    P(x::Int, y::Int=1) :: Point
    
P function convert (x, y) coordinates to `Point()`.
"""
function P(x::Int, y::Int=1; dx=ΔX, dy=ΔY) :: Point
    @assert x > 0 "x ∈ [1 2 3 ...]"
    @assert y > 0 "y ∈ [1 2 3 ...]"
    
    O + dx*(x-1) + dy*(y-1)
end

"""
    P() = O

P function default point to origin point `O`.
"""
P() = O

"""
    init_qbit_line()

Draw n lines for n QBits.
"""
function init_qbit_line(nQBits=1; dx=ΔX, dy=ΔY)
    # nQBits = 4
    StartX = -50
    StartY = 0
    EndX = 200
    # TODO: Move those to parameter list.
    
    LineStartP = Point(StartX, StartY)
    LineEndP = Point(EndX, 0)
    for y in 1:nQBits
        line(LineStartP, LineEndP, :stroke)
        txtQbit(StartX-30, y)
        LineStartP += ΔY
        LineEndP += ΔY
    end
end

function sub(substr) :: AbstractString
    "<sub>$substr</sub>"
end

function sup(substr) :: AbstractString
    "<sup>$substr</sup>"
end

function txtQbit(StartX::Int, lines::Int, init::Int=-1; dy=ΔY)
    @assert lines >= 1 "lines >= 1"
    @assert init in [-1, 0, 1] "Init state should be 0 or 1"
    
    pos = Point(StartX, 0) + dy*(lines-1) 
    initState = init==-1 ? "?" : string(init)
    text = "|" * string(initState) * ">" *
            sub("Q"*string(lines))
    # In fact it support HTML code `&#10217;`
    # ⟩, U+27E9
    
    # setfont("Helvetica", 24)
    settext(
        text, pos;
        halign = "center",
        valign = "center",
        angle  = 0, # degrees!
        markup = true
    )
    
end

#= 
    Gates 
=#

"""
    gate(C::Point, edge_len=20, txt="H")

Draw simple gates with box.
"""
function gate(C::Point, txt="H", edge_len=20)
    # TODO: support long gates
    # draw background
    sethue("white") 
    box(C, edge_len, edge_len, :fill)
    
    # draw border
    sethue("black") 
    box(C, edge_len, edge_len, :stroke)
    
    # write text in box
    # sethue("black")
    fontsize(edge_len)
    # fontface("Times New Roman")
    text(
        txt,
        C,
        halign = :center, 
        valign = :middle
    )
end
gate(C::Point, txt::Char) = gate(C, string(txt))
gate(C::Point, txt::Char, edge_len) = 
    gate(C, string(txt), edge_len)


"""
    NotControlCircle(C::Point, size=:9, color=:"white")

Draw white hollow point represent *Not Control Node*.
"""
function NotControlCircle(C::Point, d=18, color="white")
    r = d/2
    sethue(color)
    circle(C, r, :fill)
    sethue("black")
    circle(C, r, :stroke)
end

"""
    ControlCircle(C::Point, d=10)

Draw black solid point represent *Control Node*.
"""
function ControlCircle(C::Point, d=10)
    r = d/2
    color = "black"
    NotControlCircle(C, r, color)
end

"""
    Not(C::Point, d=18)

Draw a circle containing a cross represent *Not Gate*.
"""
function Not(C::Point, d=18)
    r = d/2
    dY = Point(0, r)
    circle(C, r, :stroke)
    line(C+dY, C-dY, :stroke)
end

function Cross(C::Point, width=18)
    Δ = width/2
    dx = Point(Δ, 0)
    dy = Point(0, Δ)
    lt = C - dx + dy
    rb = C + dx - dy
    line(lt, rb, :stroke)
    
    rt = C + Δ
    lb = C - Δ
    line(rt, lb, :stroke)
end


"""
    Toffoli(d::Dict, col::Int=1)

General Toffoli Gate.

Input dict format:
```julia
d = Dict(
    1 => "",    # "" or "C" for Control Node
    2 => "C",
    3 => "NC"   # "NC" for Not Control Node
    4 => "T"    # "T" for controlled qbit(Not Gate)
)
```
"""
function Toffoli(d::Dict, col::Int=1)
    ks = collect(keys(d))
    upper = P(col, minimum(ks))
    lower = P(col, maximum(ks))
    line(upper, lower, :stroke)
    
    for (y, typ) in d
        if typ == "" || typ == "C"
            ControlCircle(P(col, y))
        elseif typ == "NC"
            NotControlCircle(P(col, y))
        elseif typ == "T"
            Not(P(col, y))
        end
    end

end

"""

Draw general multi Qbits gate, you can draw single Qbit too.

Input dict format:
```julia
d = Dict(
    # Node
    1 => "",    # "" or "C" for "Control Node"
    2 => "C",
    3 => "NC"   # "NC" for "Not Control Node"
    6 => "X",   # "X" for "Cross Node"
    
    # Single Gate
    4 => "N",   # "N" for "Not Gate"
    7 => "SG:X" # start with "SG:", follow 1 char "X"
                # for type "X" single Gate
)
```
"""
function MultiQBitGate(QBits::Dict, col::Int)
    ks = collect(keys(QBits))
    upper = P(col, minimum(ks))
    lower = P(col, maximum(ks))
    line(upper, lower, :stroke)
    
    for (y, typ) in QBits
        if typ == "" || typ == "C"
            ControlCircle(P(col, y))
        elseif typ == "NC"
            NotControlCircle(P(col, y))
        elseif typ == "N"
            Not(P(col, y))
        elseif typ == "X"
            Cross(P(col, y))
        elseif startswith(typ, "SG:") && length(typ)==4
            # TODO: support long gates
            gateType = typ[end]
            gate(P(col, y), gateType)
        end
    end
end

function MeasureG(C::Point)
    body
end



@svg begin
nQbits = 8
nGates = 1
rulers()
init_qbit_line(nQbits)


gate(P(), "α")
gate(P(2), 'H')
gate(P(3), "U")
gate(P(4), "-Z")
gate(P(2,2), "H")

NotControlCircle(P(1,2))
ControlCircle(P(1,3))
Not(P(1,4))
Cross(P(1,5))

Toffoli(Dict(2=>"",3=>"",4=>"NC",5=>"T"), 3)
MultiQBitGate(Dict(2=>"",3=>"",4=>"NC",5=>"N"), 4)
MultiQBitGate(
    Dict(
        1=>"X",  2=>"",  3=>"",
        4=>"NC", 5=>"N", 6=>"SG:H",
        7=>"SG:X", 8=>"SG:ρ"
    ), 
    5
)
end
