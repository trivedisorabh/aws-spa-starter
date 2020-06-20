import React, {useEffect, useState} from "react";

export function App() {
    const [msg, setMsg] = useState('')
    useEffect(() => {
        fetch('https://bzvpkxtgvi.execute-api.eu-west-1.amazonaws.com/test/alkdsfj').then(resp => {
            console.log(resp.status)
            if (resp.status === 200) {
                resp.json().then(json => {
                        setMsg(json.msg)
                    }
                )
            } else {

                resp.text().then(txt => {
                    setMsg(txt)
                })
            }
        }).catch(e => {
            console.error(e)
        })

    }, [])
    return (<div>
        <h1>Hello World!</h1>
        <p>{msg}</p>
    </div>)
}
