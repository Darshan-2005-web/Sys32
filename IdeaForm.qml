import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: ideaForm
    color: "#ffffff"
    radius: 10
    border.color: "#e0e0e0"
    border.width: 1

    signal submitIdea(var ideaData)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Enter Your Idea Details"
            font.pointSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        TextField {
            id: ideaTitle
            placeholderText: "Idea Title"
            Layout.fillWidth: true
        }

        TextArea {
            id: ideaDescription
            placeholderText: "Describe your idea..."
            Layout.fillWidth: true
            Layout.preferredHeight: 100
        }

        ComboBox {
            id: scaleComboBox
            model: ["Small", "Medium", "Large"]
            Layout.fillWidth: true
        }

        Flow {
            Layout.fillWidth: true
            spacing: 10

            CheckBox {
                id: webPlatformCheck
                text: "Web Platform"
            }

            CheckBox {
                id: securityCheck
                text: "Security Features"
            }

            CheckBox {
                id: mobileCheck
                text: "Mobile App"
            }

            CheckBox {
                id: aiCheck
                text: "AI/ML Features"
            }
        }

        Button {
            text: "Analyze Idea"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var features = []
                if (webPlatformCheck.checked) features.push("web_platform")
                if (securityCheck.checked) features.push("security")
                if (mobileCheck.checked) features.push("mobile")
                if (aiCheck.checked) features.push("ai_ml")

                var ideaData = {
                    "title": ideaTitle.text,
                    "description": ideaDescription.text,
                    "scale": scaleComboBox.currentText.toLowerCase(),
                    "features": features
                }
                submitIdea(ideaData)
            }
        }
    }
}
