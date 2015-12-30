class EventID extends Event {
	int id;
}

class Period {

	dur length;

	int resolution;

	PeriodNode node;

	fun void init(dur length_in) {
		length_in => length;
	}

	fun void add_by_ratio(EventID event, int count, int resolution) {
		(length/resolution)*count => dur time;
		node.get(time).addEvent(event);
	}

	fun PeriodNode @ get_by_percent(float percent) {
		length * percent => dur time;
		return node.get(time);
	}

	fun void play() {
		node @=> PeriodNode @ cursor;
		cursor.fire();
		while (!cursor.isLast()) {
			cursor.timeToNext() => now;
			cursor.next @=> cursor;
			cursor.fire();
		}
	}
}

class PeriodNode
{
	dur timing;

	EventID events[0];
	int eventid;
	PeriodNode @ prev;
	PeriodNode @ next;

	fun void fire() {
		for (0 => int i; i< events.size(); i++) {
			eventid => events[i].id;
			events[i].signal();
		}
	}

	fun void addEvent(EventID event) {
		events << event;
		event.id => eventid;
	}

	fun PeriodNode @ createNode(dur time) {
		PeriodNode p;
		time => p.timing;
		return p;
	}
	
	fun PeriodNode @ get(dur time) {
		if (timeEqual(time))
			return this;
		if (timeBeforeMe(time)){
			if(isFirst())
				return prepend_start(createNode(time));
			if(timeAfterPrev(time))
				return prepend(createNode(time));
			else
				return prev.get(time);
		}
		if (timeAfterMe(time)){
			if(isLast())
				return append_end(createNode(time));
			if(timeBeforeNext(time))
				return append(createNode(time));
			else
				return next.get(time);
		}
			
	}


	fun PeriodNode @ append(PeriodNode @ node) {
		next @=> PeriodNode @ tempNext;
		node @=> tempNext.prev;
		node @=> next;
		tempNext @=> node.next;
		this @=> node.prev;
		return node;
	}
	fun PeriodNode @ prepend(PeriodNode @ node) {
		prev @=> PeriodNode @ tempPrev;
		node @=> tempPrev.next;
		node @=> prev;
		tempPrev @=> node.prev;
		this @=> node.next;
		return node;
	}
	fun PeriodNode @ append_end(PeriodNode @ node) {
		node @=> next;
		return node;
	}
	fun PeriodNode @ prepend_start(PeriodNode @ node) {
		node @=> prev;
		return node;
	}


	fun int timeEqual(dur time) {
		return time == timing;
	}
	fun int timeAfterMe(dur time) {
		return time > timing;
	}
	fun int timeBeforeMe(dur time) {
		return time < timing;
	}
	fun int timeAfterPrev(dur time) {
		return time > prev.timing;
	}
	fun int timeBeforeNext(dur time) {
		return time < next.timing;
	}


	fun int isFirst() {
		return prev == null;
	}
	fun int isLast() {
		return next == null;
	}

	fun dur timeToNext() {
		return next.timing - timing;
	}
	fun dur timeToPrev() {
		return timing - prev.timing;
	}
}

fun PeriodNode[] createDispSeq(int beat_resolution, float displace_amount, float cycle, Period period) {
	//beat_resolution:  # beats in sequence
	//displace_amount: how affected 0 (off) > x > 0.17677
	//		(higher values start doing wierd things with sync)
	//cycle: 2 means fast start & end
	//	-2 means fast middle
	//	Values < > 2: create a sine segment, or repetitions
    PeriodNode @ sequencer[beat_resolution];
    for (0 => int i; i<beat_resolution; 1 +=> i) {
	    i $ float / beat_resolution => float linear_position;
	    -Math.sin(Math.PI*cycle*linear_position) => float displacement;
	    displacement*displace_amount => float final_displacement;
	    linear_position + final_displacement => float position;
	    period.get_by_percent(position) @=> sequencer[i];
    }
    return sequencer;
}


fun void play(EventID e)
{
	Mandolin m => JCRev r => dac;

	Scale s;
	Note n;
	n.init("C-4");
	s.init(n, ["P1", "m3","M9", "m7","P1", "m3", "P5", "m7"]);
	int roll;
	1 => int dir;

	while (true) {
		e => now;
		<<< e.id >>>;
		s.get(roll%8).freq() => m.freq;
		roll+1 => roll;
		((roll%16)/512.0) * (1-((roll%2)*0.1)) * ((roll%4)+1) => m.pluck;
	}
}

fun void sampler(EventID ev, string file_in) {
	me.sourceDir() + file_in => string filename;
	SndBuf buf => dac;
	0 => buf.loop;
	0 => buf.rate;
	filename => buf.read;
	while (true) {
		ev => now;
		if (ev.id == 0){
			0.7 => buf.gain;
		}
		if (ev.id >0){
			if (ev.id%4 == 0)
				0.5 => buf.gain;
			else{
				if (ev.id%2 == 0)
				0.3 => buf.gain;
			else
				0.2 => buf.gain;
			}
		}
		0 => buf.pos;
		1 => buf.rate;
	}
}


Period p;
p.init(2::second);


createDispSeq(16, 0.01, 1.5, p) @=> PeriodNode seq[];
createDispSeq(16, 0.01, 1.2, p) @=> PeriodNode seq2[];

EventID e;
spork ~ play(e);
EventID kick;
spork ~ sampler(kick, "data/kick.wav");
EventID snare;
spork ~ sampler(snare, "data/snare.wav");
EventID hat;
spork ~ sampler(hat, "data/hihat.wav");

me.yield();

for (0 => int i; i< seq.size(); 1 +=> i){
	i => hat.id;
	seq[i].addEvent(hat);
}

for (0 => int i; i< seq2.size(); 1 +=> i){
	i => e.id;
	seq2[i].addEvent(e);
}
seq[0].addEvent(kick);
seq[4].addEvent(snare);
seq[8].addEvent(kick);
seq[10].addEvent(kick);
seq[12].addEvent(snare);

while (true) {
	spork ~ p.play();
	p.length => now;
}



1000::ms => now;

