using Luxor


"""
    P(x::Int, y::Int) :: Point
    
P function convert (x, y) coordinates to `Point()`.
"""
function P(x::Int, y::Int) :: Point
    @assert x > 0 "x ∈ [1 2 3 ...]"
    @assert y > 0 "y ∈ [1 2 3 ...]"
    
    # TODO: Move ΔX, ΔY to parameter list.
    ΔX = Point(25, 0)
    ΔY = Point(0, 40)
    
    O + ΔX*(x-1) + ΔY*(y-1)
end

"""
    P() = O

P function default point to origin point `O`.
"""
P() = O

"`P(x::Int) = P(x, 1)`"
P(x::Int) = P(x, 1)


"""
    gate(C, edge_len=20, txt="H")

Draw simple gates with box.
"""
function gate(C, edge_len=20, txt="H")

    # draw background
    sethue("white") 
    box(C, edge_len, edge_len, :fill)
    
    # draw border
    sethue("black") 
    box(C, edge_len, edge_len, :stroke)
    
    # write text in box
    # sethue("black")
    fontsize(edge_len)
    fontface("Helvetica")
    text(
        txt,
        C,
        halign = :center, 
        valign = :middle
    )
end


"""
    init_qbit_line()

Draw n lines for n QBits.
"""
function init_qbit_line()
    nQBits = 4
    StartX = -50
    StartY =  0
    ΔX = Point(25, 0)
    ΔY = Point(0, 40)
    # TODO: Move those to parameter list.
    
    LineStartP = Point(StartX, StartY)
    LineEndP = Point(100, 0)
    for _ in 1:nQBits
        line(LineStartP, LineEndP, :stroke)
        LineStartP += ΔY
        LineEndP += ΔY
    end
end

"""
    NotControlCircle(C::Point, size=:9, color=:"white")
    

"""
function NotControlCircle(C::Point, d=18, color="white")
    r = d/2
    sethue(color)
    circle(C, r, :fill)
    sethue("black")
    circle(C, r, :stroke)
end

function ControlCircle(C::Point, d=6)
    r = d/2
    color = "black"
    NotControlCircle(C, r, color)
end

function Not(C::Point, d=18)
    r = d/2
    ΔY = Point(0, r)
    circle(C, r, :stroke)
    line(C+ΔY, C-ΔY, :stroke)
end

function Toffoli(args)
    body
end



@svg begin
nQbits = 4
nGates = 1
ΔX = Point(25, 0)
ΔY = Point(0, 40)
rulers()
init_qbit_line()
gate(P(), 20, "X")
gate(P(2), 20, "H")
gate(P(3), 20, "U")
gate(P(4), 20, "-Z")
gate(P(2,2), 20, "H")

NotControlCircle(P(1,2))
ControlCircle(P(1,3))
Not(P(1,4))
end
