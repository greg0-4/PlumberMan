//0 no nothing
U0 Song()
{
  Fs->task_end_cb=&SndTaskEndCB;
  MusicSettingsRst;
  music.tempo= 4.846;
  music.stacatto_factor= 0.341;
  try {
    while (!ScanKey) {
	Play("5qtCqE");
    }
  } catch
    PutExcept;
  Snd;
}

Song;
