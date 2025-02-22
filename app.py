from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Data storage
data_dir = "data"
if not os.path.exists(data_dir):
    os.makedirs(data_dir)

class IdeaAnalyzer:
    def __init__(self):
        self.software_costs = {
            "development_tools": 1000,
            "cloud_services": 200,
            "licenses": 500,
            "security_tools": 300
        }
        
        self.hardware_costs = {
            "servers": 2000,
            "workstations": 1500,
            "networking": 500,
            "storage": 300
        }
    
    def analyze_idea(self, idea_data):
        # Analyze the idea and calculate requirements
        required_software = []
        required_hardware = []
        total_investment = 0
        
        # Analyze software requirements
        if "web_platform" in idea_data.get("features", []):
            required_software.extend(["development_tools", "cloud_services"])
            total_investment += self.software_costs["development_tools"]
            total_investment += self.software_costs["cloud_services"]
        
        if "security" in idea_data.get("features", []):
            required_software.append("security_tools")
            total_investment += self.software_costs["security_tools"]
        
        # Analyze hardware requirements
        if idea_data.get("scale", "") == "large":
            required_hardware.extend(["servers", "networking"])
            total_investment += self.hardware_costs["servers"]
            total_investment += self.hardware_costs["networking"]
        
        return {
            "required_software": required_software,
            "required_hardware": required_hardware,
            "estimated_investment": total_investment,
            "guidance": self._generate_guidance(idea_data)
        }
    
    def _generate_guidance(self, idea_data):
        guidance = []
        
        # Basic guidance for all ideas
        guidance.append("Start with a minimum viable product (MVP)")
        guidance.append("Focus on user feedback and iteration")
        
        # Specific guidance based on idea type
        if "web_platform" in idea_data.get("features", []):
            guidance.append("Consider cloud scalability from the start")
        
        if "security" in idea_data.get("features", []):
            guidance.append("Implement security measures early in development")
        
        return guidance

analyzer = IdeaAnalyzer()

@app.route('/api/analyze', methods=['POST'])
def analyze_idea():
    try:
        idea_data = request.json
        if not idea_data:
            return jsonify({"error": "No data provided"}), 400
        
        analysis = analyzer.analyze_idea(idea_data)
        return jsonify(analysis)
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/ideas', methods=['GET', 'POST'])
def handle_ideas():
    ideas_file = os.path.join(data_dir, "ideas.json")
    
    if request.method == 'POST':
        idea = request.json
        try:
            if os.path.exists(ideas_file):
                with open(ideas_file, 'r') as f:
                    ideas = json.load(f)
            else:
                ideas = []
            
            ideas.append(idea)
            
            with open(ideas_file, 'w') as f:
                json.dump(ideas, f)
            
            return jsonify({"message": "Idea saved successfully"})
        
        except Exception as e:
            return jsonify({"error": str(e)}), 500
    
    else:  # GET
        try:
            if os.path.exists(ideas_file):
                with open(ideas_file, 'r') as f:
                    ideas = json.load(f)
                return jsonify(ideas)
            return jsonify([])
        
        except Exception as e:
            return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
