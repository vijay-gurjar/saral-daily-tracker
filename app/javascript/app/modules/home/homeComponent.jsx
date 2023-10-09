import React from 'react';
import './home.styles.scss'
import AttendanceDashboard from "../attendanceDashboard/attendanceDashboard";
import HeaderBar from "../header/header";
import TlWiseAgentReport from "../tlWiseAgentReport/tlWiseAgentReport";
import AgentWiseReport from "../agentWiseReport/agentWiseReport";
import Attendance from "../attendace/attendance";
import MinimumCallConnected from "../minimumCallConnected/minimumCallConnected";
import FileUpload from "../fileUpload/fileUpload";


const HomeComponent = () => {

    return (
        <>
            <HeaderBar />
            {/*<MinimumCallConnected />*/}
            <FileUpload />
        </>
    );
}

export default HomeComponent;