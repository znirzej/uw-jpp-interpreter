all:
	happy -gca ParMatal.y
	alex -g LexMatal.x
	ghc --make TestMatal.hs -o TestMatal
	ghc --make Interpret.hs -o interpret
clean:
	-rm -f *.log *.aux *.hi *.o *.dvi interpret TestMatal

distclean: clean
	-rm -f DocMatal.* LexMatal.* ParMatal.* LayoutMatal.* SkelMatal.* PrintMatal.* TestMatal.* AbsMatal.* TestMatal ErrM.* SharedString.* ComposOp.* Matal.dtd XMLMatal.* Makefile*
	

