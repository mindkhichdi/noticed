module Noticed
  module DeliveryMethods
    class Email < Base
      option :mailer

      def deliver
        mailer.with(format).send(method.to_sym).deliver_later
      end

      private

      def mailer
        options.fetch(:mailer).constantize
      end

      def method
        options[:method] || notification.class.name.underscore
      end

      def format
        if (method = options[:format])
          notification.send(method)
        else
          notification.params.merge(
            recipient: recipient,
            record: record
          )
        end
      end
    end
  end
end
