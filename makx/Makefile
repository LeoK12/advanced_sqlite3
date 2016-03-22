test : test.c ../sqlite3.c
	gcc -o test -g test.c ../sqlite3.c -ldl -lpthread -DSQLITE_ENABLE_WAL_CHECKPOINT_OPTIMIZATION -DNUSE_TRANSACTION
clean :
	rm -f test test.db*
