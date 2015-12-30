public class Note
{
	static int to_index[];
	new int[0] @=> to_index;
	0 => to_index["C"];
	1 => to_index["C#"];
	1 => to_index["Db"];
	2 => to_index["D"];
	3 => to_index["D#"];
	3 => to_index["Eb"];
	4 => to_index["E"];
	5 => to_index["F"];
	6 => to_index["F#"];
	6 => to_index["Gb"];
	7 => to_index["G"];
	8 => to_index["G#"];
	8 => to_index["Ab"];
	9 => to_index["A"];
	10 => to_index["A#"];
	10 => to_index["Bb"];
	11 => to_index["B"];

	["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"] @=> static string to_string_flats[];
	["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"] @=> static string to_string_sharps[];

	int note;

	fun void init(string note_string) {
		note_string.find("-") => int sep;
		note_string.substring(sep+1).toInt() => int note_octave;
		to_index[note_string.substring(0, sep)] => int note_note;

		note_octave*12 + note_note => note;
	}
	fun void init(int note_index) {
		note_index => note;
	}

	fun Note add(Interval interval) {
		Note n;
		note + interval.semitones() => int total;
		n.init(total);
		return n;
		
	}

	fun Note subtract(Interval interval) {
		Note n;
		note - interval.semitones() => int total;
		n.init(total);
		return n;
		
	}

	fun int index() {
		return note;
	}

	fun int get_octave() {
		return note/12;
	}

	fun int get_pitch_class() {
		return note%12;
	}

	fun string str(string flats_or_sharps) {
		string notename;
		if (flats_or_sharps == "flats")
			to_string_flats[get_pitch_class()] => notename;
		if (flats_or_sharps == "sharps")
			to_string_sharps[get_pitch_class()] => notename;
		return notename + "-" + get_octave();
	}

	fun float freq() {
		return Math.mtof(note);
	}
}
