import os
import numpy as np
import sounddevice as sd
from scipy.io.wavfile import write
import torch
from speechbrain.inference.speaker import SpeakerRecognition
from PrintBig import print_big

# ==============================
# CONFIG
# ==============================
SAMPLE_RATE = 16000
DURATION = 7  # seconds per recording
VOICE_DB = "voices"

os.makedirs(VOICE_DB, exist_ok=True)

# Load SpeechBrain model
model = SpeakerRecognition.from_hparams(
    source="speechbrain/spkrec-ecapa-voxceleb",
    savedir="pretrained_model"
)

# ==============================
# RECORD AUDIO
# ==============================
def record_audio(filename):
    print("🎤 Recording...")
    audio = sd.rec(int(SAMPLE_RATE * DURATION), samplerate=SAMPLE_RATE, channels=1)
    sd.wait()
    write(filename, SAMPLE_RATE, audio)
    print("✅ Saved:", filename)


# ==============================
# SAVE NEW PERSON
# ==============================
def save_voice():
    name = input("Enter name: ").strip()
    filepath = os.path.join(VOICE_DB, f"{name}.wav")
    record_audio(filepath)
    print(f"👤 Voice saved for {name}")


# ==============================
# LOAD DATABASE
# ==============================
def load_known_voices():
    voices = {}
    for file in os.listdir(VOICE_DB):
        if file.endswith(".wav"):
            name = file.replace(".wav", "")
            voices[name] = os.path.join(VOICE_DB, file)
    return voices


# ==============================
# RECOGNIZE SPEAKER
# ==============================
def recognize():
    known_voices = load_known_voices()
    if not known_voices:
        print("⚠️ No saved voices!")
        return

    print("🎧 Listening... (Ctrl+C to stop)")

    while True:
        temp_file = "temp.wav"
        record_audio(temp_file)

        best_score = 0
        best_name = "Unknown"

        for name, file in known_voices.items():
            score, prediction = model.verify_files(temp_file, file)

            if score > best_score:
                best_score = score
                best_name = name

        # Threshold (tune this!)
        if best_score > 0.55:
            # print(f"🟢 Detected: {best_name} (score={best_score.item():.2f})")
            print(f"\n🟢 Detected: {best_name}")
            print_big(best_name)
        else:
            print(f"🔴 Unknown (score={best_score.item():.2f})")


# ==============================
# MAIN MENU
# ==============================
while True:
    print("\n1. Save new voice")
    print("2. Recognize speaker")
    print("3. Exit")

    choice = input("Choose: ")

    if choice == "1":
        save_voice()
    elif choice == "2":
        recognize()
    elif choice == "3":
        break