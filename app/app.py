from flask import Flask, render_template, request, jsonify
import os
import json
import boto3

def create_app():
    app = Flask(__name__)
    sns = boto3.client("sns", region_name=os.getenv("AWS_REGION", "us-east-1"))
    SNS_TOPIC_ARN = os.getenv("CONTACT_SNS_TOPIC_ARN")

    @app.post("/api/contact")
    def contact():
        data = request.get_json(force=True)

        # Basic validation
        required = ["first_name", "last_name", "email", "message"]
        missing = [k for k in required if not data.get(k)]
        if missing:
            return (
                jsonify(
                    {
                        "error": "Missing required fields",
                        "missing_fields": missing,
                    }
                ),
                400,
            )
        
        payload = {
        "first_name": data["first_name"].strip(),
        "last_name": data["last_name"].strip(),
        "email": data["email"].strip().lower(),
        "phone": (data.get("phone") or "").strip(),
        "message": data["message"].strip(),
        "source": "portfolio-contact-form"
    }

        # Publish to SNS (SNS fans out to SQS)
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=json.dumps(payload),
            Subject="New portfolio contact form submission"
        )

        return jsonify({"ok": True}), 200

    @app.route("/")
    def index():
        return render_template("index.html", page_title="Brandon's Portfolio")

    return app

# For local development: `python app.py`
if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=8000, debug=True)
