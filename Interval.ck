public class Interval
{
	[0, 1, 3, 5, 7, 8, 10] @=> static int to_semitones_degree_base[];

	static int to_semitones_quality_mod[];
	new int[0] @=> to_semitones_quality_mod;
	0 => to_semitones_quality_mod["P"];
	0 => to_semitones_quality_mod["m"];
	1 => to_semitones_quality_mod["M"];
	-1 => to_semitones_quality_mod["d"];
	1 => to_semitones_quality_mod["A"];

	fun static int to_semitones(string interval_string) {
		interval_string.substring(0, 1) => string quality;
		interval_string.substring(1).toInt()-1 => int degree;
		degree / 7 => int octave;
		degree % 7 => degree;

		to_semitones_degree_base[degree] => int semitones_base;
		to_semitones_quality_mod[quality] => int semitones_mod;
		octave * 12 => int octave_mod;

		semitones_base + semitones_mod + octave_mod => int total;

		return total;
	}

	["P", "m", "M", "m", "M", "P", "d", "P", "m", "M", "m", "M"] @=> static string from_semitones_quality[];
	[1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7] @=> static int from_semitones_degree[];

	fun static string to_string(int semitones) {
		semitones / 12 => int octave;	
		semitones % 12 => semitones;
		from_semitones_quality[semitones] => string quality;
		from_semitones_degree[semitones] => int degree;
		degree + octave*7 => degree;
		quality + degree => string result;

		return result;
	}

	int interval;

	fun void init(string interval_string) {
		to_semitones(interval_string) => interval;
	}
	fun void init(int interval_semitones) {
		interval_semitones => interval;
	}
	fun Interval add(Interval other) {
		Interval i;
		(interval + other.semitones()) => int total;
		i.init(total);
		return i;
		
	}
	fun Interval subtract(Interval other) {
		Interval i;
		(interval - other.semitones()) => int total;
		if (total < 0) {
			-total => total;
		}
		i.init(total);
		return i;
	}

	fun Interval normalize() {
		Interval i;
		i.init(interval%12);
		return i;
	}
	fun string str() {
		return to_string(interval);
	}
	fun int semitones() {
		return interval;
	}
}
