public class Scale {

	Note @root;
	Interval @ intervals[];
	Note @lowest;
	Note @highest;

	fun void init(Note root_note, Interval interval_list[]) {
		root_note @=> root;
		interval_list @=> intervals;
	}

	fun void init(Note root_note, string interval_list[]) {
		root_note @=> root;
		new Interval[interval_list.size()] @=> intervals;
		for (0 => int i; i< interval_list.size(); i++) {
			new Interval @=> intervals[i];
			intervals[i].init(interval_list[i]);
		}
	}

	fun void setRange(Note lowest_in, Note highest_in) {
		lowest_in @=> lowest;
		highest_in @=> highest;
	}
	
	fun Note get(int index) {
		index%intervals.size() => int degree;
		index/intervals.size() => int octave;
		if (degree < 0){
			intervals.size() + degree => degree;
			octave-1 => octave;
		}
		
		intervals[degree] @=> Interval @ int_degree;
		Interval int_octave;
		int_octave.init(octave*12);
		int_octave.add(int_degree) @=> Interval @ int_total;
		
		return root.add(int_total);
	}

}

/*
Scale s;
Note n;
n.init("C-4");
s.init(n, ["P1", "M2", "M3", "P4", "P5", "M6", "M7"]);

for (-10 => int i; i< 10; i++) {
	<<< s.get(i).str("sharps") >>>;
}
*/
