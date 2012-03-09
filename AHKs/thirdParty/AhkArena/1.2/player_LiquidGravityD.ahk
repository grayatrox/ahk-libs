LiquidGravityDScript()
{
  GLOBAL
  FileRead, 1Units, AllUnitList.txt
  StringSplit, aunit, 1Units, |
  1refreshloop := aunit0-1
  Loop %1refreshloop%
  {
    1currentunit := aunit%a_index%
    If !1currentunit
      continue
    StringGetPos, Position, 1currentunit, _
    StringLeft, player, 1currentunit, Position
    If (player = LiquidGravityDenemy)
      Continue
    1currentclass := %1currentunit%_class
    Gosub, LiquidGravityDClass%1currentclass%
  }
return

LiquidGravityDClass1: ; Commander
  If (LiquidGravityDResources > 3)
  {
    If (LiquidGravityDClass2unitCount = 0)
      AA_Build(101020, 1currentunit, 2)
    If (LiquidGravityDClass5unitCount = 0)
      AA_Build(004000, 1currentunit, 5,"U")
    If (LiquidGravityDClass4unitCount = 0)
      AA_Build(000400, 1currentunit, 4,"UL")
    If (LiquidGravityDClass1unitCount = 1)
      AA_Build(020000, 1currentunit, 1,"L")
    If (LiquidGravityDClass2unitCount > 3)
      AA_Build(101101, 1currentunit, 3) ;if more than 3 workers, build an attacker
    Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
      AA_Build(101020, 1currentunit, 2) ; otherwise, build a worker
  }
return

LiquidGravityDClass2: ; Gatherer
  ;msgbox, gather subroutine initiated for unit %1currentunit%
  If AA_Gather(1currentunit) = 2
  {
    ;msgbox, no minerals in range, determining nearest mineral
    1distanceold = 999
    Loop 15 
    {
      If (mineral%a_index%value > 0) ;if a mineral has value > 0
      {
        1target = mineral%a_index%
        1xgatherdistance := abs(%1target%x - %1currentunit%_posx) 
        1ygatherdistance := abs(%1Target%y - %1currentunit%_posy)
        1distancenew := 1xgatherdistance+1ygatherdistance
        ;msgbox, total distance to mineral = %1distancenew%
        If (1distancenew < 1distanceold)
        {
          1distanceold := 1distancenew
          1nearestmineral := 1target
          ;msgbox, new nearest mineral found! %1target%
        }
      }
    }
    ;msgbox, begin move towards %1NEARESTMINERAL%
    1xgatherdistance := %1nearestmineral%x - %1currentunit%_posx 
    1ygatherdistance := %1nearestmineral%y - %1currentunit%_posy
    ;msgbox, 1xgatherdistance = %1xgatherdistance% and 1ygatherdistance = %1ygatherdistance%
    If (1xgatherdistance = 0)
      1xvalue =
    If (1xgatherdistance < 0)
      1xvalue = L
    If (1xgatherdistance > 0)
      1xvalue = R
    If (1ygatherdistance = 0)
      1yvalue =
    If (1ygatherdistance > 0)
      1yvalue = D
    If (1ygatherdistance < 0)
      1yvalue = U
    1Dir := 1xvalue . 1yvalue
    ;msgbox, direction to travel determined to be %1dir%
    If AA_Move(1currentunit, 1Dir) = 5
      AA_Move(1currentunit, "R")
    return
  }
  If AA_Gather(1currentunit) = 4
    AA_Scan(1currentunit)
return


LiquidGravityDClass3: ;Soldier
  ;msgbox, %1currentunit% class 3 initiated
  1nearestenemy := LiquidGravityDFindNearestEnemy(1currentunit)
  If AA_Attack(1currentunit, 1nearestenemy) = 2
  {
    ;msgbox, begin move towards %1NEARESTENEMY%
    1xdistance := %1nearestenemy%_posx - %1currentunit%_posx 
    1ydistance := %1nearestenemy%_posy - %1currentunit%_posy
    ;msgbox, 1xdistance = %1xdistance% and 1ydistance = %1ydistance%
    If (1xdistance = 0)
      1xvalue =
    If (1xdistance < 0)
      1xvalue = L
    If (1xdistance > 0)
      1xvalue = R
    If (1ydistance = 0)
      1yvalue =
    If (1ydistance > 0)
      1yvalue = D
    If (1ydistance < 0)
      1yvalue = U
    1Dir := 1xvalue . 1yvalue
    ;msgbox, direction to travel determined to be %1dir%
    If AA_Move(1currentunit, 1Dir) = 5
      AA_Move(1currentunit, "R")
    return
  }
  If AA_Attack(1currentunit, 1nearestenemy) = 4
  {
    ;msgbox, enemy not scanned. scanning now.
    AA_Scan(1currentunit)
  }
return


LiquidGravityDClass4: ; Watchtower
  ;msgbox, %1currentunit% class 4 initiated
  1nearestenemy := LiquidGravityDFindNearestEnemy(1currentunit)
  If AA_Attack(1currentunit, 1nearestenemy) = 4
  {
    ;msgbox, enemy not scanned. scanning now.
    AA_Scan(1currentunit)
  }
return


LiquidGravityDClass5: ; Sniper
  ;msgbox, %1currentunit% class 5 initiated
  AA_Scan(1currentunit)
return
}


LiquidGravityDFindNearestEnemy(1currentunit)
{
  FileRead, 1Units, AllUnitList.txt   
  StringSplit, aunit, 1Units, |
  refreshloop2 := aunit0-1
  1distanceold = 999
  Loop %refreshloop2%
  {
    1checkunit := aunit%a_index%
    StringGetPos, Position, 1checkunit, _
    StringLeft, player, 1checkunit, Position
    ;msgbox checking unit %1checkunit%. unti belongs to %player%
    If (player = "LiquidGravityD")
      Continue
    ;msgbox, player belongs to lagos, the enemy. continuing attack.
    1xdistance := abs(%1checkunit%_posx - %1currentunit%_posx) 
    1ydistance := abs(%1checkunit%_posy - %1currentunit%_posy)
    1distancenew := 1xdistance+1ydistance
    If (1distancenew < 1distanceold)
    {
      1distanceold := 1distancenew
      1nearestenemy := 1checkunit
      ;msgbox, new nearest enemy found! %checkunit%
    }
  }
Return, 1nearestenemy
}
