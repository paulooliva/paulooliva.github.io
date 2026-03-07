def lastWheelAngle(wheels):
    # Write your code here
    first = wheels[0]
    last = wheels[-1]
    d = first % last if last <= first else first
    angle = 360 / last
    total_angle = round(d * angle) % 360
    if len(wheels) % 2 == 1:
        total_angle = 360 - total_angle 
    return total_angle % 360
