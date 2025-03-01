@echo off
if x%1==xfast goto fast
if x%1==xsafe goto safe
if x%1==xverysafe goto verysafe
if x%1==xfastvid goto fastvid
if x%1==xfastsnd goto fastsnd
if x%1==xmax goto max

echo -------------------------------------------------------------------
echo Options for running QWCL:
echo  qwc max:      all features on, but doesn't work on all systems
echo  qwc fast:     maximum speed, but doesn't work on all systems
echo  qwc fastvid:  maximum video speed, but safer, probably slower sound
echo  qwc fastsnd:  maximum sound speed, but safer, probably slower video
echo  qwc safe:     very likely to run, but may be slower
echo  qwc verysafe: almost sure to run, but probably slower, and no sound
echo -------------------------------------------------------------------
goto done

:max
qwcl -dinput %2 %3 %4 %5 %6 %7 %8 %9
goto done

:fast
qwcl %2 %3 %4 %5 %6 %7 %8 %9
goto done

:fastvid
qwcl -wavonly %2 %3 %4 %5 %6 %7 %8 %9
goto done

:fastsnd
qwcl -nodirectdraw -nowindirect %2 %3 %4 %5 %6 %7 %8 %9
goto done

:safe
qwcl -nodirectdraw -nowindirect -wavonly %2 %3 %4 %5 %6 %7 %8 %9
goto done

:verysafe
qwcl -dibonly -nosound -nojoy %2 %3 %4 %5 %6 %7 %8 %9
:done
