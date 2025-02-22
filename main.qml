import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: "Entrepreneur Idea Visualization App"

    // Center the window on screen
    Screen.onDevicePixelRatioChanged: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"

        StackLayout {
            id: mainStack
            anchors.fill: parent
            anchors.margins: 20

            IdeaForm {
                id: ideaForm
                Layout.fillWidth: true
                Layout.fillHeight: true

                onSubmitIdea: function(ideaData) {
                    busyIndicator.running = true
                    sendRequest(ideaData)
                }
            }

            ResultsView {
                id: resultsView
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: false
            z: 1
        }
    }

    // Error dialog
    Dialog {
        id: errorDialog
        title: "Error"
        standardButtons: Dialog.Ok
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        modal: true

        Label {
            id: errorText
            text: ""
        }
    }

    function sendRequest(ideaData) {
        var xhr = new XMLHttpRequest()
        xhr.open("POST", "http://localhost:5000/api/analyze")
        xhr.setRequestHeader("Content-Type", "application/json")
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                busyIndicator.running = false
                
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    resultsView.showResults(response)
                    mainStack.currentIndex = 1
                } else {
                    errorText.text = "Failed to analyze idea. Please try again."
                    errorDialog.open()
                }
            }
        }

        xhr.onerror = function() {
            busyIndicator.running = false
            errorText.text = "Network error occurred. Please check if the server is running."
            errorDialog.open()
        }

        xhr.send(JSON.stringify(ideaData))
    }
}
