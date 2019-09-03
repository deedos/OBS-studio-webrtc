#include "VideoCapturer.h"

#include "api/video/i420_buffer.h"
#include "api/video/video_frame_buffer.h"
#include "api/video/video_rotation.h"

#include <algorithm>

VideoCapturer::VideoCapturer() : AdaptedVideoTrackSource(4) {}
VideoCapturer::~VideoCapturer() = default;

void VideoCapturer::OnFrameCaptured(const webrtc::VideoFrame &frame)
{
    int adapted_width;
    int adapted_height;
    int crop_width;
    int crop_height;
    int crop_x;
    int crop_y;

    if (!AdaptFrame(frame.width(), frame.height(), frame.timestamp_us(),
                    &adapted_width, &adapted_height, &crop_width, &crop_height,
                    &crop_x, &crop_y)) {
        // Drop frame in order to respect frame rate constraint.
        return;
    }

    if (adapted_width != frame.width() || adapted_height != frame.height()) {
        // Video adapter has requested a down-scale. Allocate a new buffer and
        // return scaled version.
        rtc::scoped_refptr<webrtc::I420Buffer> scaled_buffer =
                webrtc::I420Buffer::Create(adapted_width, adapted_height);

        scaled_buffer->ScaleFrom(*frame.video_frame_buffer()->ToI420());

        OnFrame(webrtc::VideoFrame::Builder()
                .set_video_frame_buffer(scaled_buffer)
                .set_rotation(webrtc::kVideoRotation_0)
                .set_timestamp_us(frame.timestamp_us())
                .set_id(frame.id())
                .build());
    } else {
        // No adaptations needed, just return the frame as is.
        OnFrame(frame);
    }
}
