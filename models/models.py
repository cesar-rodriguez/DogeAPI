#!/usr/bin/python3

import boto3
import os
from io import BytesIO
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship

from database.configuration import Base


class Blog(Base):
    """
    Blog class

    Args:
        Base (sqlalchemy.ext.declarative.api.Base): Base class
    """

    __tablename__ = "blogs"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    _s3_key = Column("s3_key", String)
    user_id = Column(Integer, ForeignKey("users.id"))
    creator = relationship("User", back_populates="blogs")

    @property
    def s3_key(self):
        return self._s3_key

    @s3_key.setter
    def s3_key(self, value):
        self._s3_key = value

    def get_body(self):
        """
        Get the body of the blog post from S3.

        Returns:
            str: The body of the blog post.
        """
        if not self.s3_key:
            # Handle the case where s3_key is None
            print("Blog post does not have a valid S3 key.")
            return ""

        s3 = boto3.client("s3")
        bucket_name = os.environ.get("S3_BUCKET_NAME")
        obj = s3.get_object(Bucket=bucket_name, Key=self.s3_key)
        body = obj["Body"].read().decode("utf-8")
        return body

    def set_body(self, body):
        """
        Set the body of the blog post in S3.

        Args:
            body (str): The body of the blog post.
        """
        if not self.s3_key:
            raise ValueError("s3_key must be set before storing the blog body")

        if body is None:
            raise ValueError("Blog body must not be empty")

        s3 = boto3.client("s3")
        bucket_name = os.environ.get("S3_BUCKET_NAME")
        buffer = BytesIO(body.encode("utf-8"))
        s3.upload_fileobj(buffer, bucket_name, self.s3_key)

    def delete_body(self):
        """
        Delete the body of the blog post from S3.
        """
        s3 = boto3.client("s3")
        bucket_name = os.environ.get("S3_BUCKET_NAME")
        s3.delete_object(Bucket=bucket_name, Key=self.s3_key)

    body = property(get_body, set_body)

    def delete(self, session):
        """
        Delete the blog post and its body from S3.

        Args:
            session (sqlalchemy.orm.session.Session): The database session.
        """
        self.delete_body()
        session.delete(self)

    def __init__(self, *args, **kwargs):
        self._s3_key = None
        super().__init__(*args, **kwargs)


class User(Base):
    """
    User class

    Args:
        Base (sqlalchemy.ext.declarative.api.Base): Base class
    """

    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    email = Column(String)
    password = Column(String)
    blogs = relationship("Blog", back_populates="creator")
