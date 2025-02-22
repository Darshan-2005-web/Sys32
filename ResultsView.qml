import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: resultsView
    color: "#ffffff"
    radius: 10
    border.color: "#e0e0e0"
    border.width: 1
    visible: false

    property var analysisData: null

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Analysis Results"
            font.pointSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Required Software Section
        GroupBox {
            title: "Required Software"
            Layout.fillWidth: true

            ListView {
                id: softwareList
                width: parent.width
                height: contentHeight
                model: analysisData ? analysisData.required_software : []
                delegate: Text {
                    text: "• " + modelData
                    font.pointSize: 12
                    padding: 5
                }
            }
        }

        // Required Hardware Section
        GroupBox {
            title: "Required Hardware"
            Layout.fillWidth: true

            ListView {
                id: hardwareList
                width: parent.width
                height: contentHeight
                model: analysisData ? analysisData.required_hardware : []
                delegate: Text {
                    text: "• " + modelData
                    font.pointSize: 12
                    padding: 5
                }
            }
        }

        // Investment Section
        GroupBox {
            title: "Estimated Investment"
            Layout.fillWidth: true

            Text {
                text: analysisData ? "$" + analysisData.estimated_investment.toLocaleString() : "$0"
                font.pointSize: 16
                font.bold: true
                color: "#2ecc71"
            }
        }

        // Guidance Section
        GroupBox {
            title: "Guidance"
            Layout.fillWidth: true

            ListView {
                id: guidanceList
                width: parent.width
                height: contentHeight
                model: analysisData ? analysisData.guidance : []
                delegate: Text {
                    text: "• " + modelData
                    font.pointSize: 12
                    padding: 5
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
            }
        }

        Button {
            text: "Back to Form"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                resultsView.visible = false
            }
        }
    }

    function showResults(data) {
        analysisData = data
        visible = true
    }
}
