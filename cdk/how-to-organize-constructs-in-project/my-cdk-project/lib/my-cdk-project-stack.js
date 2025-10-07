"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MyCdkProjectStack = void 0;
const cdk = __importStar(require("aws-cdk-lib"));
const secure_s3_bucket_1 = require("./constructs/secure-s3-bucket"); // <-- IMPORT IT
class MyCdkProjectStack extends cdk.Stack {
    constructor(scope, id, props) {
        super(scope, id, props);
        // Instantiate your custom construct just like any other CDK construct
        const mySecureBucket = new secure_s3_bucket_1.SecureS3Bucket(this, 'MyWebsiteData', {
            // You can still override properties if you allow it via props
            bucketName: 'my-unique-website-data-bucket-12345',
        });
        // You can access the underlying resources via public properties
        new cdk.CfnOutput(this, 'BucketNameOutput', {
            value: mySecureBucket.bucket.bucketName,
        });
    }
}
exports.MyCdkProjectStack = MyCdkProjectStack;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibXktY2RrLXByb2plY3Qtc3RhY2suanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyJteS1jZGstcHJvamVjdC1zdGFjay50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBLGlEQUFtQztBQUVuQyxvRUFBK0QsQ0FBQyxnQkFBZ0I7QUFFaEYsTUFBYSxpQkFBa0IsU0FBUSxHQUFHLENBQUMsS0FBSztJQUM5QyxZQUFZLEtBQWdCLEVBQUUsRUFBVSxFQUFFLEtBQXNCO1FBQzlELEtBQUssQ0FBQyxLQUFLLEVBQUUsRUFBRSxFQUFFLEtBQUssQ0FBQyxDQUFDO1FBRXhCLHNFQUFzRTtRQUN0RSxNQUFNLGNBQWMsR0FBRyxJQUFJLGlDQUFjLENBQUMsSUFBSSxFQUFFLGVBQWUsRUFBRTtZQUMvRCw4REFBOEQ7WUFDOUQsVUFBVSxFQUFFLHFDQUFxQztTQUNsRCxDQUFDLENBQUM7UUFFSCxnRUFBZ0U7UUFDaEUsSUFBSSxHQUFHLENBQUMsU0FBUyxDQUFDLElBQUksRUFBRSxrQkFBa0IsRUFBRTtZQUMxQyxLQUFLLEVBQUUsY0FBYyxDQUFDLE1BQU0sQ0FBQyxVQUFVO1NBQ3hDLENBQUMsQ0FBQztJQUNMLENBQUM7Q0FDRjtBQWZELDhDQWVDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0ICogYXMgY2RrIGZyb20gJ2F3cy1jZGstbGliJztcbmltcG9ydCB7IENvbnN0cnVjdCB9IGZyb20gJ2NvbnN0cnVjdHMnO1xuaW1wb3J0IHsgU2VjdXJlUzNCdWNrZXQgfSBmcm9tICcuL2NvbnN0cnVjdHMvc2VjdXJlLXMzLWJ1Y2tldCc7IC8vIDwtLSBJTVBPUlQgSVRcblxuZXhwb3J0IGNsYXNzIE15Q2RrUHJvamVjdFN0YWNrIGV4dGVuZHMgY2RrLlN0YWNrIHtcbiAgY29uc3RydWN0b3Ioc2NvcGU6IENvbnN0cnVjdCwgaWQ6IHN0cmluZywgcHJvcHM/OiBjZGsuU3RhY2tQcm9wcykge1xuICAgIHN1cGVyKHNjb3BlLCBpZCwgcHJvcHMpO1xuXG4gICAgLy8gSW5zdGFudGlhdGUgeW91ciBjdXN0b20gY29uc3RydWN0IGp1c3QgbGlrZSBhbnkgb3RoZXIgQ0RLIGNvbnN0cnVjdFxuICAgIGNvbnN0IG15U2VjdXJlQnVja2V0ID0gbmV3IFNlY3VyZVMzQnVja2V0KHRoaXMsICdNeVdlYnNpdGVEYXRhJywge1xuICAgICAgLy8gWW91IGNhbiBzdGlsbCBvdmVycmlkZSBwcm9wZXJ0aWVzIGlmIHlvdSBhbGxvdyBpdCB2aWEgcHJvcHNcbiAgICAgIGJ1Y2tldE5hbWU6ICdteS11bmlxdWUtd2Vic2l0ZS1kYXRhLWJ1Y2tldC0xMjM0NScsXG4gICAgfSk7XG5cbiAgICAvLyBZb3UgY2FuIGFjY2VzcyB0aGUgdW5kZXJseWluZyByZXNvdXJjZXMgdmlhIHB1YmxpYyBwcm9wZXJ0aWVzXG4gICAgbmV3IGNkay5DZm5PdXRwdXQodGhpcywgJ0J1Y2tldE5hbWVPdXRwdXQnLCB7XG4gICAgICB2YWx1ZTogbXlTZWN1cmVCdWNrZXQuYnVja2V0LmJ1Y2tldE5hbWUsXG4gICAgfSk7XG4gIH1cbn0iXX0=