import React, {useState} from "react";
import MicRecorder from 'mic-recorder-to-mp3';

const Mp3Recorder = new MicRecorder({bitRate: 128});

interface Prop {
    question: string
}

export function Question(prop: Prop) {
    const [blob, setblob] = useState('')
    const [recording, setRecording] = useState(false)

    return (
        <div className="App">
            <p>{prop.question}</p>
            {blob && <audio controls src={blob}/>}
            {!recording ?
                <button onClick={() => {
                    startRecording(setRecording)
                }}>spela in</button>
                : <button onClick={(e) => {
                    stopRecording(setblob, setRecording)
                }}>stop</button>}
            {blob && <button onClick={() => {setblob('')}} >Delete</button>}
        </div>
    );
}

function stopRecording(setblob: (url: string) => void, setRecording: (value: boolean) => void) {
    Mp3Recorder
        .stop()
        .getMp3()
        .then((data: any) => {
            let [buffer, blob] = data
            const blobURL = URL.createObjectURL(blob)
            console.log(blobURL, blob, buffer)
            setblob(blobURL)
            setRecording(false)
        })
        .catch((e: any) => {
            console.error(e)
            setRecording(false)
        })

}

function startRecording(setRecording: (value: boolean) => void) {
    Mp3Recorder
        .start()
        .then(() => {
            setRecording(true)
        })
        .catch((e: Error) => {
            setRecording(false)
            console.error(e)
        })
}