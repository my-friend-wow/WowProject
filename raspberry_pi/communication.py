from dotenv import load_dotenv
from openai import OpenAI
import azure.cognitiveservices.speech as speechsdk
import logging
import os
import re


load_dotenv()


class WowAudioAssistant:
    def __init__(self, openai_api_key, azure_speech_key, azure_service_region):
        self.azure_stt_result = ""
        self.openai_api_key = openai_api_key
        self.azure_speech_key = azure_speech_key
        self.azure_service_region = azure_service_region
        self.answer_text = ""

    def stt(self):
        """
        Azure Speech Service를 이용해 Speech-to-Text
        최대 30sec 또는 침묵이 감지될 때까지 실시간 녹음 후 텍스트 변환
        """
        speech_config = speechsdk.SpeechConfig(subscription=self.azure_speech_key, region=self.azure_service_region)
        speech_config.speech_recognition_language="ko-KR"

        audio_config = speechsdk.audio.AudioConfig(use_default_microphone=True)
        speech_recognizer = speechsdk.SpeechRecognizer(speech_config=speech_config, audio_config=audio_config)

        print("Speak into your microphone.")
        speech_recognition_result = speech_recognizer.recognize_once_async().get()

        if speech_recognition_result.reason == speechsdk.ResultReason.RecognizedSpeech:
            print("Recognized: {}".format(speech_recognition_result.text))
        elif speech_recognition_result.reason == speechsdk.ResultReason.NoMatch:
            print("No speech could be recognized: {}".format(speech_recognition_result.no_match_details))
        elif speech_recognition_result.reason == speechsdk.ResultReason.Canceled:
            cancellation_details = speech_recognition_result.cancellation_details
            print("Speech Recognition canceled: {}".format(cancellation_details.reason))
            if cancellation_details.reason == speechsdk.CancellationReason.Error:
                print("Error details: {}".format(cancellation_details.error_details))
                print("Did you set the speech resource key and region values?")
        
        self.azure_stt_result = speech_recognition_result.text

        return self.azure_stt_result

    def gpt(self):
        """
        OpenAI API를 이용해 답변 텍스트 생성
        """
        if self.azure_stt_result == "":
            self.answer_text = "오류가 발생했어요. 문제가 계속된다면 관리자에게 문의하세요."
            logging.error("GPT API 실행 전 STT Result가 비어있습니다.")
            return self.answer_text
        
        content_text = self.azure_stt_result
        client = OpenAI(api_key=self.openai_api_key)

        response_chat = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "상대는 초등학생이야. 한국어로 답변해줘."},
                {"role": "user", "content": content_text},
            ]
        )

        raw_content = response_chat.choices[0].message.content
        filtered_content = re.sub(r"[^a-zA-Zㄱ-ㅎ가-힣0-9! .?]", "", raw_content)

        self.answer_text = filtered_content
        
        print(self.answer_text)
        
        return self.answer_text

    def tts(self):
        """
        Azure Speech Service를 이용해 Text-to-Speech
        """
        speech_key = self.azure_speech_key
        service_region = self.azure_service_region

        speech_config = speechsdk.SpeechConfig(subscription=speech_key, region=service_region)

        speech_config.speech_synthesis_voice_name = "ko-KR-SeoHyeonNeural"

        if self.answer_text == "":
            text = "오류가 발생했어요. 문제가 계속된다면 관리자에게 문의하세요."
            logging.error("TTS API 실행 전 Answer Text Result가 비어있습니다.")

        text = self.answer_text

        speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config)

        result = speech_synthesizer.speak_text_async(text).get()

        if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
            print("Speech synthesized for text [{}]".format(text))
        elif result.reason == speechsdk.ResultReason.Canceled:
            cancellation_details = result.cancellation_details
            print("Speech synthesis canceled: {}".format(cancellation_details.reason))
            if cancellation_details.reason == speechsdk.CancellationReason.Error:
                print("Error details: {}".format(cancellation_details.error_details))


if __name__ == '__main__':
    log_file = 'communication.log'
    logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    # while - button 감지되면 시작 - sleep 20 sec
    
    assistant = WowAudioAssistant(
        openai_api_key=os.getenv('OPENAI_API_KEY'),
        azure_speech_key=os.getenv('SPEECH_KEY'),
        azure_service_region=os.getenv('SERVICE_REGION')
    )

    assistant.stt()
    assistant.gpt()
    assistant.tts()    
