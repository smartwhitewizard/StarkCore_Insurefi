import React from 'react'
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"


type Props = {}

const ReviewSection = (props: Props) => {
  return (
    <section className="w-full py-12 md:py-24 lg:py-32 bg-neutral-300">
      <div className="container px-4 md:px-6">
        <div className="grid gap-8 md:grid-cols-2">
          <div className="space-y-4">
            <h2 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">What Our Customers Say</h2>
            <p className="text-muted-foreground md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
              Hear from real customers about their experience with StarkCore.
            </p>
          </div>
          <div className="grid gap-6">
            <div className="rounded-lg border bg-neutral-200 p-6 shadow-sm">
              <div className="flex items-start space-x-4">
                <Avatar>
                  <AvatarImage src="https://github.com/shadcn.png" />
                  <AvatarFallback>JD</AvatarFallback>
                </Avatar>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <h4 className="font-medium">John Doe</h4>
                    <span className="text-xs text-muted-foreground">Homeowner</span>
                  </div>
                  <p className="text-muted-foreground">
                    "StarkCore has been a lifesaver for me. Their coverage is comprehensive and their
                    customer service is top-notch. I highly recommend them to anyone looking for reliable
                    insurance."
                  </p>
                </div>
              </div>
            </div>
            <div className="rounded-lg border bg-neutral-200 p-6 shadow-sm">
              <div className="flex items-start space-x-4">
                <Avatar>
                  <AvatarImage src="https://github.com/shadcn.png" />
                  <AvatarFallback>JA</AvatarFallback>
                </Avatar>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <h4 className="font-medium">Jane Appleseed</h4>
                    <span className="text-xs text-muted-foreground">Small Business Owner</span>
                  </div>
                  <p className="text-muted-foreground">
                    "I've been with StarkCore for years and they've always been there for me. Their business
                    insurance coverage is comprehensive and their claims process is seamless. I wouldn't trust
                    my business with anyone else."
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default ReviewSection