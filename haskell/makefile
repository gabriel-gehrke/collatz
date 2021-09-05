all: collatz collatz_brootforce

collatz: Collatz.hs CollatzMain.hs
	ghc -O2 CollatzMain.hs -o collatz
	strip collatz

collatz_brootforce: Collatz.hs CollatzBrootforceMain.hs
	ghc -O2 CollatzBrootforceMain.hs -o collatz_brootforce
	strip collatz_brootforce

clean:
	rm -f *.hi *.o collatz collatz_brootforce
