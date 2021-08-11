collatz.elf: collatz.o
	ld collatz.o -o collatz.elf

collatz.o: collatz.s
	as collatz.s -o collatz.o

clean:
	rm -f collatz.o collatz.elf
