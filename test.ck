<<< 9 / 12 >>>;
<<< "5".toInt() >>>;


"Db-4" => string note;
note.find("-") => int sep;
<<< note.substring(sep+1)>>>;
<<< note.substring(0, sep)>>>;


Object @ o;
<<< o == null >>>;


class A {
	fun A returnThis() {
		return this;
	}
}

class B extends A {

}

fun A doSomething(A theclass) {
	return theclass;
}

A ok;
<<< ok.returnThis() >>>;
B pk;

doSomething(pk);

<<< 2 * 2::second >>>;


/*
fun string display(Interval i) {
	return i.str() + " (" + i.semitones() + ")";
}


//["P1","m2","M2","m3","M3","P4","d5","P5","m6","M6","m7","M7", "P8", "m9", "M9", "m10", "M10", "P11", "d12", "P12", "m13", "M13", "m14", "M14", "P15", "m16", "M16"] @=>  string interval_names[];
["P1","m2","M2","m3","M3","P4","d5","P5"] @=>  string interval_names[];
for (0 => int i; i< interval_names.size(); i++) {
	Interval int1;
	int1.init(interval_names[i]);
	for (0 => int j; j< interval_names.size(); j++) {
		Interval int2;
		int2.init(interval_names[j]);

		int1.subtract(int2).normalize() @=> Interval @sum;
		
		<<< display(int1) + "\t-\t" + display(int2) + "   \t=\t" + display(sum) + "\t" >>>;
	}
}
*/



/*["P1","m2","M2","m3","M3","P4","d5","P5","m6","M6","m7","M7", "P8", "m9", "M9", "m10", "M10", "P11", "d12", "P12", "m13", "M13", "m14", "M14", "P15", "m16", "M16"] @=>  string interval_names[];

Note n;
n.init("C");

for (0 => int i; i< interval_names.size(); i++) {
	Interval a;
	a.init(interval_names[i]);

	Note @o;
	n.add(a) @=> o;
	<<< o.str("sharps") >>>;
}
*/


/*
for (0 => int i; i< interval_names.size(); i++) {
	Interval a;
	a.init(interval_names[i]);

	Note @o;
	n.add(a) @=> o;
	<<< a.str() >>>;
	<<< o.str("flats") >>>;
}
*/

/*
p.add_by_ratio(e, 7, 8);
p.add_by_ratio(e, 6, 8);

p.add_by_ratio(e, 0, 8);
p.add_by_ratio(e, 1, 8);

*/
