# OpenShift ISO Share

Deploy an nginx-based file server with a PersistentVolumeClaim to store and share ISO images via HTTP.

## Quick Start

```bash
# Create a new project (or use existing)
oc new-project iso-share

# Deploy all resources
oc apply -k .

# Get the share URL
oc get route iso-share
```

## Uploading an ISO

After the pod is running, copy your ISO to the PVC:

```bash
# Get the pod name
POD=$(oc get pods -l app=iso-share -o jsonpath='{.items[0].metadata.name}')

# Upload your ISO
oc cp /path/to/your-image.iso $POD:/usr/share/nginx/html/
```

Or using `rsync` for large files (resumable):

```bash
oc rsync /path/to/your-image.iso $POD:/usr/share/nginx/html/
```

## Accessing the ISO

1. Get the Route hostname: `oc get route iso-share -o jsonpath='{.spec.host}'`
2. Open `https://<hostname>/` to see the directory listing
3. Click your ISO filename to download, or use: `https://<hostname>/your-image.iso`

## Customization

- **Storage size**: Edit `pvc.yaml` and change `storage: 10Gi` to your needs
- **Route hostname**: Add `spec.host: your-custom-name.apps.example.com` to `route.yaml` for a custom URL
- **Red Hat image**: If your cluster restricts external images, change the deployment to use `registry.access.redhat.com/ubi9/nginx-126:latest` (adjust mount path to `/opt/app-root/etc/nginx.d/` if needed)
