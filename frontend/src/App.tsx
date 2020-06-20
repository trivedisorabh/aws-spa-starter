import React from "react";

import './App.css';
import {Question} from "./Question";

function App() {
    return (
        <div>
            <Question question="Vem är du?" />
            <Question question="Vad gör du här?" />
            <Question question="Såg du skurken?" />
        </div>
    )
}

export default App;
