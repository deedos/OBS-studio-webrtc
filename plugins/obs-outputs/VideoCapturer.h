#ifndef _OBS_VIDEO_CAPTURER_
#define _OBS_VIDEO_CAPTURER_

#include "api/scoped_refptr.h"
#include "media/base/adapted_video_track_source.h"
#include "rtc_base/ref_counted_object.h"
// #include "media/base/video_adapter.h"
// #include "rtc_base/thread.h"

class VideoCapturer : public rtc::AdaptedVideoTrackSource {
public:
    VideoCapturer();
    ~VideoCapturer() override;

    void OnFrameCaptured(const webrtc::VideoFrame &frame);

    // VideoTrackSourceInterface API
    bool is_screencast() const override { return false; }
    absl::optional<bool> needs_denoising() const override { return false; }

    // MediaSourceInterface API
    webrtc::MediaSourceInterface::SourceState state() const override
    {
        return webrtc::MediaSourceInterface::SourceState::kLive;
    }
    bool remote() const override { return false; }

    static rtc::scoped_refptr<VideoCapturer> Create()
    {
        return new rtc::RefCountedObject<VideoCapturer>();
    }

private:
    // rtc::Thread *start_thread_;
    // cricket::VideoAdapter video_adapter_;
};

#endif
