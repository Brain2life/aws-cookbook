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
exports.SecureS3Bucket = void 0;
const constructs_1 = require("constructs");
const s3 = __importStar(require("aws-cdk-lib/aws-s3"));
const aws_cdk_lib_1 = require("aws-cdk-lib");
class SecureS3Bucket extends constructs_1.Construct {
    bucket;
    constructor(scope, id, props) {
        super(scope, id);
        this.bucket = new s3.Bucket(this, 'SecureBucket', {
            ...props, // Pass through any standard bucket props
            // Enforce your security best practices
            blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
            encryption: s3.BucketEncryption.S3_MANAGED,
            enforceSSL: true,
            versioned: true,
            removalPolicy: aws_cdk_lib_1.RemovalPolicy.RETAIN, // Safer default for production
        });
    }
}
exports.SecureS3Bucket = SecureS3Bucket;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2VjdXJlLXMzLWJ1Y2tldC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbInNlY3VyZS1zMy1idWNrZXQudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQSwyQ0FBdUM7QUFDdkMsdURBQXlDO0FBQ3pDLDZDQUE0QztBQU81QyxNQUFhLGNBQWUsU0FBUSxzQkFBUztJQUMzQixNQUFNLENBQVk7SUFFbEMsWUFBWSxLQUFnQixFQUFFLEVBQVUsRUFBRSxLQUEwQjtRQUNsRSxLQUFLLENBQUMsS0FBSyxFQUFFLEVBQUUsQ0FBQyxDQUFDO1FBRWpCLElBQUksQ0FBQyxNQUFNLEdBQUcsSUFBSSxFQUFFLENBQUMsTUFBTSxDQUFDLElBQUksRUFBRSxjQUFjLEVBQUU7WUFDaEQsR0FBRyxLQUFLLEVBQUUseUNBQXlDO1lBQ25ELHVDQUF1QztZQUN2QyxpQkFBaUIsRUFBRSxFQUFFLENBQUMsaUJBQWlCLENBQUMsU0FBUztZQUNqRCxVQUFVLEVBQUUsRUFBRSxDQUFDLGdCQUFnQixDQUFDLFVBQVU7WUFDMUMsVUFBVSxFQUFFLElBQUk7WUFDaEIsU0FBUyxFQUFFLElBQUk7WUFDZixhQUFhLEVBQUUsMkJBQWEsQ0FBQyxNQUFNLEVBQUUsK0JBQStCO1NBQ3JFLENBQUMsQ0FBQztJQUNMLENBQUM7Q0FDRjtBQWhCRCx3Q0FnQkMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBDb25zdHJ1Y3QgfSBmcm9tICdjb25zdHJ1Y3RzJztcbmltcG9ydCAqIGFzIHMzIGZyb20gJ2F3cy1jZGstbGliL2F3cy1zMyc7XG5pbXBvcnQgeyBSZW1vdmFsUG9saWN5IH0gZnJvbSAnYXdzLWNkay1saWInO1xuXG4vLyBEZWZpbmUgdGhlIHByb3BlcnRpZXMgeW91ciBjb25zdHJ1Y3Qgd2lsbCBhY2NlcHRcbmV4cG9ydCBpbnRlcmZhY2UgU2VjdXJlUzNCdWNrZXRQcm9wcyBleHRlbmRzIHMzLkJ1Y2tldFByb3BzIHtcbiAgLy8gWW91IGNhbiBhZGQgY3VzdG9tIHByb3BlcnRpZXMgaGVyZSBpZiBuZWVkZWRcbn1cblxuZXhwb3J0IGNsYXNzIFNlY3VyZVMzQnVja2V0IGV4dGVuZHMgQ29uc3RydWN0IHtcbiAgcHVibGljIHJlYWRvbmx5IGJ1Y2tldDogczMuQnVja2V0O1xuXG4gIGNvbnN0cnVjdG9yKHNjb3BlOiBDb25zdHJ1Y3QsIGlkOiBzdHJpbmcsIHByb3BzOiBTZWN1cmVTM0J1Y2tldFByb3BzKSB7XG4gICAgc3VwZXIoc2NvcGUsIGlkKTtcblxuICAgIHRoaXMuYnVja2V0ID0gbmV3IHMzLkJ1Y2tldCh0aGlzLCAnU2VjdXJlQnVja2V0Jywge1xuICAgICAgLi4ucHJvcHMsIC8vIFBhc3MgdGhyb3VnaCBhbnkgc3RhbmRhcmQgYnVja2V0IHByb3BzXG4gICAgICAvLyBFbmZvcmNlIHlvdXIgc2VjdXJpdHkgYmVzdCBwcmFjdGljZXNcbiAgICAgIGJsb2NrUHVibGljQWNjZXNzOiBzMy5CbG9ja1B1YmxpY0FjY2Vzcy5CTE9DS19BTEwsXG4gICAgICBlbmNyeXB0aW9uOiBzMy5CdWNrZXRFbmNyeXB0aW9uLlMzX01BTkFHRUQsXG4gICAgICBlbmZvcmNlU1NMOiB0cnVlLFxuICAgICAgdmVyc2lvbmVkOiB0cnVlLFxuICAgICAgcmVtb3ZhbFBvbGljeTogUmVtb3ZhbFBvbGljeS5SRVRBSU4sIC8vIFNhZmVyIGRlZmF1bHQgZm9yIHByb2R1Y3Rpb25cbiAgICB9KTtcbiAgfVxufSJdfQ==